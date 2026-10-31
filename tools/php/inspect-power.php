<?php
/**
 * Inspect declarations and class bodies with PHP's tokenizer; never execute input.
 * Usage: php -n inspect-power.php CODE SETTINGS INDEX_ENTRY BODY compare|skip
 */
if ($argc !== 6)
{
	fwrite(STDERR, "Expected code, settings, index entry, body and comparison mode.\n");
	exit(2);
}
try
{
	$code = file_get_contents($argv[1]);
	$settings = json_decode(file_get_contents($argv[2]), true, 512, JSON_THROW_ON_ERROR);
	$entry = json_decode(file_get_contents($argv[3]), true, 512, JSON_THROW_ON_ERROR);
	$sourceBody = file_get_contents($argv[4]);
	if (preg_match('/\A\s*<\?(?:php|=)/i', $sourceBody))
	{
		throw new RuntimeException('code.power must contain a declaration body, not a complete PHP file.');
	}
	// Unexpanded placeholders can be invalid PHP until compilation. Parse ordinary
	// bodies only; both source syntax and body equality are deferred for expansions.
	if ($argv[5] === 'compare')
	{
		token_get_all('<?php ' . $settings['type'] . ' AiDocBodyProbe {' . "\n" . $sourceBody . "\n}", TOKEN_PARSE);
	}
	$tokens = token_get_all($code, TOKEN_PARSE);
	$significant = [];
	$offset = 0;

	foreach ($tokens as $token)
	{
		$text = is_array($token) ? $token[1] : $token;
		$id = is_array($token) ? $token[0] : null;

		if (!in_array($id, [T_WHITESPACE, T_COMMENT, T_DOC_COMMENT], true))
		{
			$significant[] = ['id' => $id, 'text' => $text, 'offset' => $offset];
		}

		$offset += strlen($text);
	}

	$namespaces = [];
	$declarations = [];
	$count = count($significant);

	for ($i = 0; $i < $count; $i++)
	{
		$token = $significant[$i];

		if ($token['id'] === T_NAMESPACE)
		{
			$namespace = '';

			for ($j = $i + 1; $j < $count && !in_array($significant[$j]['text'], [';', '{'], true); $j++)
			{
				$namespace .= $significant[$j]['text'];
			}

			$namespaces[] = $namespace;
		}

		if (!in_array($token['id'], [T_CLASS, T_INTERFACE, T_TRAIT], true)
			|| ($significant[$i + 1]['id'] ?? null) !== T_STRING)
		{
			continue; // Includes anonymous classes and Foo::class expressions.
		}

		$type = $token['text'];

		if (in_array($significant[$i - 1]['id'] ?? null, [T_ABSTRACT, T_FINAL], true))
		{
			$type = $significant[$i - 1]['text'] . ' ' . $type;
		}

		$name = $significant[$i + 1]['text'];
		$j = $i + 2;

		while ($j < $count && $significant[$j]['text'] !== '{')
		{
			$j++;
		}

		if ($j === $count)
		{
			throw new RuntimeException('Missing declaration body.');
		}

		$start = $significant[$j]['offset'] + 1;
		$depth = 1;

		for ($j++; $j < $count; $j++)
		{
			$current = $significant[$j];

			if (($current['id'] === null && $current['text'] === '{')
				|| in_array($current['id'], [T_CURLY_OPEN, T_DOLLAR_OPEN_CURLY_BRACES], true))
			{
				$depth++;
			}
			elseif ($current['id'] === null && $current['text'] === '}')
			{
				$depth--;

				if ($depth === 0)
				{
					break;
				}
			}
		}

		if ($j === $count)
		{
			throw new RuntimeException('Unbalanced declaration body.');
		}

		$declarations[] = ['type' => $type, 'name' => $name, 'body' => substr($code, $start, $significant[$j]['offset'] - $start)];
	}

	if ($namespaces !== [$entry['namespace']])
	{
		throw new RuntimeException('Actual PHP namespace does not match index.');
	}

	if (count($declarations) !== 1 || $declarations[0]['type'] !== $settings['type'] || $declarations[0]['name'] !== $settings['name'])
	{
		throw new RuntimeException('Actual PHP declaration does not match settings.');
	}

	if ($argv[5] === 'compare')
	{
		$normalize = static function (string $text): string
		{
			return trim(str_replace("\r\n", "\n", $text));
		};

		if ($normalize($sourceBody) !== $normalize($declarations[0]['body']))
		{
			throw new RuntimeException('Generated declaration body differs from code.power.');
		}
	}
}
catch (Throwable $exception)
{
	fwrite(STDERR, $exception->getMessage() . "\n");
	exit(1);
}
