<?php
/**
 * @license CC0-1.0; see LICENSE
 */
require __DIR__ . '/src/25a2c706-36eb-49ec-bbbb-be8218b101e1/code.php';

$interval = new \VDM\Joomla\AiDocExample\IntegerInterval();

foreach ([[1, 1, 3, true], [3, 1, 3, true], [0, 1, 3, false], [-2, -2, -2, true]] as $case)
{
	[$value, $minimum, $maximum, $expected] = $case;

	if ($interval->contains($value, $minimum, $maximum) !== $expected)
	{
		throw new \RuntimeException('Inclusive interval check failed.');
	}
}

try
{
	$interval->contains(1, 3, 1);
	throw new \RuntimeException('Reversed interval did not throw.');
}
catch (\InvalidArgumentException $exception)
{
	// Expected: reversed bounds are rejected.
}

echo "IntegerInterval smoke checks passed.\n";
