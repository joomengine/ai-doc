<?php
/**
 * @package    JCB.AiDoc.Examples
 * @license    CC0-1.0; see LICENSE
 */

namespace VDM\Joomla\AiDocExample;

/**
 * Documentation fixture: inclusive integer interval rule.
 *
 * @since 1.0.0
 */
final class IntegerInterval
{
	/**
	 * Test whether a value is inside an inclusive integer interval.
	 *
	 * @param   int  $value    Value to test.
	 * @param   int  $minimum  Inclusive lower bound.
	 * @param   int  $maximum  Inclusive upper bound.
	 *
	 * @return  bool
	 * @throws  \InvalidArgumentException  When the bounds are reversed.
	 * @since   1.0.0
	 */
	public function contains(int $value, int $minimum, int $maximum): bool
	{
		if ($minimum > $maximum)
		{
			throw new \InvalidArgumentException('Minimum must not exceed maximum.');
		}

		return $value >= $minimum && $value <= $maximum;
	}
}
