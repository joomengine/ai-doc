<?php
/** Read PHP literals and XML metadata only. Never include/eval the inspected source. */
declare(strict_types=1);
final class Literals
{
	private array $tokens;
	private int $i = 0;
	public function __construct(string $source) {
		$this->tokens = array_values(array_filter(token_get_all($source), static fn($t) => !is_array($t) || !in_array($t[0], [T_WHITESPACE, T_COMMENT, T_DOC_COMMENT], true)));
	}
	private function text($t): string { return is_array($t) ? $t[1] : $t; }
	private function value() {
		$t = $this->tokens[$this->i++] ?? null;
		if ($t === '[') {
			$result = [];
			while (($this->tokens[$this->i] ?? null) !== ']') {
				$first = $this->value();
				if (is_array($this->tokens[$this->i] ?? null) && $this->tokens[$this->i][0] === T_DOUBLE_ARROW) {
					$this->i++; $result[$first] = $this->value();
				} else { $result[] = $first; }
				if (($this->tokens[$this->i] ?? null) === ',') { $this->i++; }
				elseif (($this->tokens[$this->i] ?? null) !== ']') { throw new RuntimeException('Unsupported array expression'); }
			}
			$this->i++; return $result;
		}
		if ($t === '-') { return -$this->value(); }
		if (is_array($t) && $t[0] === T_CONSTANT_ENCAPSED_STRING) {
			if ($t[1][0] !== "'") { throw new RuntimeException('Only single-quoted source literals are supported'); }
			return str_replace(["\\'", "\\\\"], ["'", "\\"], substr($t[1], 1, -1));
		}
		if (is_array($t) && $t[0] === T_LNUMBER) { return (int)$t[1]; }
		if (is_array($t) && $t[0] === T_DNUMBER) { return (float)$t[1]; }
		if (is_array($t) && $t[0] === T_STRING) {
			$literal = strtolower($t[1]);
			if ($literal === 'null') { return null; }
			if ($literal === 'true') { return true; }
			if ($literal === 'false') { return false; }
		}
		throw new RuntimeException('Nonliteral expression: ' . ($t === null ? 'EOF' : $this->text($t)));
	}
	public function properties(): array {
		$out = []; $depth = 0;
		for ($this->i = 0; $this->i < count($this->tokens); $this->i++) {
			$t = $this->tokens[$this->i];
			if ($t === '{') { $depth++; } elseif ($t === '}') { $depth--; }
			if ($depth === 1 && is_array($t) && $t[0] === T_VARIABLE && ($this->tokens[$this->i + 1] ?? null) === '=') {
				$name = substr($t[1], 1); $this->i += 2;
				$out[$name] = $this->value();
				if (($this->tokens[$this->i] ?? null) !== ';') { throw new RuntimeException("Nonliteral tail for $name"); }
			}
		}
		return $out;
	}
}
function writeJson(string $file, $value): void {
	file_put_contents($file, json_encode($value, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR) . "\n");
}
function attrs(SimpleXMLElement $node): array {
	$a = []; foreach ($node->attributes() as $key => $value) { $a[$key] = (string)$value; } return $a;
}
function childFormFields(SimpleXMLElement $node): array {
	$fields = [];
	foreach ($node->children() as $child) {
		if ($child->getName() === 'field') { $fields[] = formField($child); }
		else { $fields = array_merge($fields, childFormFields($child)); }
	}
	return $fields;
}
function formField(SimpleXMLElement $node): array {
	$a = ['attributes' => (object)attrs($node), 'options' => []];
	foreach ($node->option as $option) { $a['options'][] = ['attributes' => (object)attrs($option), 'label' => trim((string)$option)]; }
	$a['nested_fields'] = childFormFields($node);
	return $a;
}
function markdown($v): string { return str_replace(["|", "\n", "\r", '`'], ['\\|', ' ', '', "'"], is_string($v) ? $v : json_encode($v, JSON_UNESCAPED_SLASHES)); }
function profile(array $field): array {
	// Null represents an exported absent value. Form/DB defaults are evidence, not insert defaults.
	if (($field['type'] ?? '') === 'subform' || isset($field['fields'])) { return ['null', 'object', 'array', 'string']; }
	if (($field['store'] ?? null) === 'json') { return ['null', 'object', 'array', 'string', 'number', 'boolean']; }
	if (preg_match('/^(TINYINT|SMALLINT|MEDIUMINT|INT|BIGINT|FLOAT|DOUBLE|DECIMAL|NUMERIC)/i', $field['db']['type'] ?? '') || in_array($field['type'] ?? '', ['radio', 'checkbox', 'checkboxes', 'list', 'integer', 'number'], true)) { return ['null', 'string', 'number']; }
	return ['null', 'string'];
}
try {
	if ($argc !== 4) { throw new RuntimeException('Usage: package-contracts.php JCB_SOURCE OUTPUT COMMIT'); }
	[$unused, $root, $out, $commit] = $argv;
	if (!extension_loaded('tokenizer') || !extension_loaded('simplexml')) { throw new RuntimeException('PHP tokenizer and SimpleXML required'); }
	$base = 'libraries/vendor_jcb/VDM.Joomla/src/';
	$source = ['repository' => 'https://github.com/vdm-io/Joomla-Component-Builder', 'commit' => $commit];
	$url = $source['repository'] . '/blob/' . $commit . '/';
	$tableFile = $base . 'Componentbuilder/Table.php';
	$tableText = file_get_contents($root . '/' . $tableFile);
	preg_match('/@license\s+([^\r\n]+)/', $tableText, $licenseMatch);
	preg_match('/@copyright\s+([^\r\n]+)/', $tableText, $copyrightMatch);
	$license = ['header' => $licenseMatch[1] ?? null, 'spdx' => isset($licenseMatch[1]) && strpos($licenseMatch[1], 'GNU General Public License version 2 or later') === 0 ? 'GPL-2.0-or-later' : null, 'copyright' => $copyrightMatch[1] ?? null, 'file' => is_file($root . '/LICENSE.txt') ? 'LICENSE.txt' : null, 'sha256' => is_file($root . '/LICENSE.txt') ? hash_file('sha256', $root . '/LICENSE.txt') : null, 'url' => is_file($root . '/LICENSE.txt') ? $url . 'LICENSE.txt' : null];
	$tables = (new Literals($tableText))->properties()['tables'];
	$defaults = (new Literals(file_get_contents($root . '/' . $base . 'Abstraction/Remote/Config.php')))->properties();
	$manifest = ['version' => 1, 'source' => $source, 'source_license' => $license, 'generation' => 'Literal PHP token parsing and XML parsing; inspected source is never executed.', 'entities' => []];
	$entities = []; $configCount = 0;
	foreach (glob($root . '/' . $base . 'Componentbuilder/Package/*/Remote/Config.php') as $configFile) {
		$configCount++;
		$config = array_replace($defaults, (new Literals(file_get_contents($configFile)))->properties());
		$entity = $config['table']; $class = basename(dirname(dirname($configFile)));
		$relative = substr($configFile, strlen($root) + 1);
		if (isset($entities[$entity])) { $entities[$entity]['config_sources'][] = ['class' => $class, 'path' => $relative, 'url' => $url . $relative, 'sha256' => hash_file('sha256', $configFile)]; continue; }
		$fields = [];
		$map = $config['map'] ?: array_combine(array_keys($tables[$entity] ?? []), array_keys($tables[$entity] ?? []));
		if (!$config['map']) { foreach ($config['ignore'] as $ignored) { unset($map[$ignored]); } }
		$formFile = 'admin/forms/' . $entity . '.xml'; $form = null;
		if (is_file($root . '/' . $formFile)) {
			$xmlText = file_get_contents($root . '/' . $formFile);
			if (stripos($xmlText, '<!DOCTYPE') !== false || stripos($xmlText, '<!ENTITY') !== false) { throw new RuntimeException('XML DTD/entities unsupported'); }
			$form = simplexml_load_string($xmlText, SimpleXMLElement::class, LIBXML_NONET);
			if ($form === false) { throw new RuntimeException("Cannot parse $formFile"); }
		}
		foreach ($map as $serialized => $fieldName) {
			$meta = $tables[$entity][$fieldName] ?? null;
			$forms = [];
			if ($form) { foreach ($form->xpath('//field[@name="' . $fieldName . '"][not(ancestor::field)]') ?: [] as $node) { $forms[] = formField($node); } }
			$fields[$serialized] = ['table_metadata' => $meta, 'config_map_target' => $fieldName, 'form' => $forms, 'static_json_types' => $meta ? profile($meta) : ['null', 'string']];
			if ($entity === 'field' && $serialized === 'xml') { $fields[$serialized]['static_json_types'] = ['null', 'string']; }
		}
		$identity = $config['guid_field'] === 'guid' ? 'guid' : (strpos($config['src_path'], '/children') !== false ? 'parent_guid' : ($entity === 'file_system' ? 'asset_key' : 'natural_key'));
		$entities[$entity] = ['entity' => $entity, 'kind' => $entity === 'file_system' ? 'filesystem' : 'database', 'config_sources' => [['class' => $class, 'path' => $relative, 'url' => $url . $relative, 'sha256' => hash_file('sha256', $configFile)]], 'config' => $config, 'identity_kind' => $identity, 'table_source' => ['path' => $tableFile, 'url' => $url . $tableFile, 'sha256' => hash_file('sha256', $root . '/' . $tableFile)], 'form_source' => $form ? ['path' => $formFile, 'url' => $url . $formFile, 'sha256' => hash_file('sha256', $root . '/' . $formFile)] : null, 'fields' => (object)$fields];
	}
	ksort($entities);
	if (isset($entities['file_system'])) { $entities['file_system']['table_source'] = null; }
	foreach ($entities as $entity => $data) {
		$data['source_license'] = $license;
		writeJson($out . '/reference/' . $entity . '.json', $data);
		$fields = (array)$data['fields']; $config = $data['config'];
		$manifest['entities'][] = ['entity' => $entity, 'kind' => $data['kind'], 'identity_kind' => $data['identity_kind'], 'key' => $config['guid_field'], 'index' => $config['index_path'], 'source_directory' => $config['src_path'], 'settings_name' => $config['settings_name'], 'children' => $config['children'], 'field_count' => count($fields), 'reference' => 'reference/' . $entity . '.json', 'guide' => 'reference/' . $entity . '.md', 'schema' => 'schemas/' . $entity . '.schema.json'];
		$sourceLink = $data['kind'] === 'filesystem' ? $data['config_sources'][0]['url'] : $url . $tableFile;
		$md = '# ' . $entity . " serialized field contract\n\nGenerated from the pinned [JCB source](" . $sourceLink . "). Read the [package protocol](../specification.md) before editing. The [machine reference]($entity.json) retains every Table property, nested field, form attribute and option; this page is its compact index.\n\n";
		if ($license['url']) { $md .= 'Upstream metadata: ' . ($license['copyright'] ?? 'See source copyright notice.') . ' [' . ($license['spdx'] ?? 'Source licence') . '](' . $license['url'] . "). Extraction does not relicense the upstream material.\n\n"; }
		$md .= 'Identity: `' . $config['guid_field'] . '` (' . $data['identity_kind'] . '). Index: `' . $config['index_path'] . '`. ';
		if ($data['kind'] === 'filesystem') {
			$md .= 'Raw payload: `' . $config['src_path'] . '/<key>' . "` (no item.json). The three fields below come from the virtual Remote Config map, not a database table or repository JSON record. See [file/folder transport](../specification.md#files-and-folders).\n\n";
		} else {
			$md .= 'Record: `' . $config['src_path'] . '/<identity>/' . $config['settings_name'] . "`.\n\n";
		}
		if ($entity === 'custom_code') { $md .= "Automated target=1 has a path-derived index GUID while the outer index bucket remains function_name; follow the [identity exception](../specification.md#typed-identities-and-supported-families), not the ordinary record-path shorthand.\n\n"; }
		if ($data['kind'] === 'database') { $md .= "Defaults below are database metadata, **not** instructions to fill absent values. Export may emit null; import skips null/missing properties rather than clearing them. DB storage encoding describes the persistence layer: repository base64 fields contain decoded text, and JSON-stored fields retain their appropriate native value (including scalar XML strings). Forms can impose conditional rules not executed by the static validator.\n\n"; }
		else { $md .= "There is no Table definition, form or SQL storage/default for this virtual entity. File/Folder Config supplies an explicit map; these fields describe transport values, while the indexed payload is a raw file or ZIP archive.\n\n"; }
		$md .= "| Serialized field | Form type | DB type/default | Storage | Relationship / nested fields |\n| --- | --- | --- | --- | --- |\n";
		$props = [];
		foreach ($fields as $name => $info) {
			$m = $info['table_metadata'];
			$md .= '| `' . $name . '` | ' . markdown($m['type'] ?? null) . ' | ' . markdown(($m['db']['type'] ?? 'virtual') . ' / ' . json_encode($m['db']['default'] ?? null)) . ' | ' . markdown($m['store'] ?? 'none') . ' | ' . markdown($m['link'] ?? (isset($m['fields']) ? $m['fields'] : null)) . " |\n";
			$props[$name] = ['type' => $info['static_json_types'], 'description' => 'Source-derived envelope; see reference/' . $entity . '.json for exact metadata, conditions and subfields.'];
		}
		if ($data['kind'] === 'database') { $md .= "\nIgnored fields: `" . implode('`, `', $config['ignore']) . "`. Standard database bookkeeping fields are not automatically appended: Remote Config calls Table::fields with its default=false argument.\n\n"; }
		else { $md .= "\nThe explicit File/Folder map bypasses the database Table field projection.\n\n"; }
		foreach ($data['config_sources'] as $configSource) { $md .= '- [Remote Config ' . $configSource['class'] . '](' . $configSource['url'] . ")\n"; }
		if ($data['form_source']) { $md .= '- [Form XML](' . $data['form_source']['url'] . ")\n"; }
		file_put_contents($out . '/reference/' . $entity . '.md', $md);
		$props['@dependencies'] = ['$ref' => 'dependencies.schema.json'];
		$schema = ['$schema' => 'https://json-schema.org/draft/2020-12/schema', 'title' => $entity . ($data['kind'] === 'filesystem' ? ' virtual Config map (not a repository JSON record)' : ' package serialized envelope'), 'description' => 'Generated from pinned Table and Remote Config. Bounds known JSON types only, not conditional forms, SQL defaults, compiler behavior or semantic closure. Filesystem payloads are raw files; their Config map is only transport metadata.', 'type' => 'object', 'properties' => (object)$props, 'additionalProperties' => false];
		if ($data['kind'] === 'database') { $schema['required'] = [$config['guid_field']]; }
		writeJson($out . '/schemas/' . $entity . '.schema.json', $schema);
	}
	$manifest['counts'] = ['config_classes' => $configCount, 'logical_entities' => count($entities), 'database_entities' => count(array_filter($entities, static fn($e) => $e['kind'] === 'database')), 'serialized_top_level_fields' => array_sum(array_column($manifest['entities'], 'field_count'))];
	writeJson($out . '/model-contracts.json', $manifest);
	$readme = "# Package field references\n\nGenerated from JCB `" . $commit . "` using `bash tools/generate-package-contracts.sh SOURCE OUTPUT`. Regenerate into a separate directory and review the diff. PHP literals are tokenized; inspected PHP is never included or executed. XML is parsed without DTD or network access.\n\nThe JSON files preserve full source field metadata and nested subfields; form options, defaults, filters, showon and validation attributes are evidence, not a complete compiler schema. The schemas are deliberately bounded envelopes and accept exported nulls. Unknown fields fail this pinned profile and require source review. See [protocol](../specification.md), [inventory](../model-contracts.json) and [tool limits](../../tools/README.md).\n\n| Entity | Identity | Fields |\n| --- | --- | --- |\n";
	foreach ($manifest['entities'] as $entry) { $readme .= '| [' . $entry['entity'] . '](' . $entry['entity'] . '.md) | `' . $entry['key'] . '` / ' . $entry['identity_kind'] . ' | ' . $entry['field_count'] . " |\n"; }
	file_put_contents($out . '/reference/README.md', $readme);
} catch (Throwable $e) { fwrite(STDERR, 'ERROR: ' . $e->getMessage() . "\n"); exit(1); }
