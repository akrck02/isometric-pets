class_name Math

## Round to given decimals
static func round_to_decimals(num : float, digit : int) -> float:
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
