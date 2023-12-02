const READ_FROM: String = "res://_INPUT_COLORS_HERE.txt"


class ColorPair:
	var name: String
	var color: Color

	func _init(_name: String, _color: Color):
		name = _name
		color = _color


## Parse the colors from the input file and return them as an array of ColorPair objects
## Returns the array sorted by color
func parse_colors() -> Array[ColorPair]:
	var output: Array[ColorPair] = []
	var file: FileAccess = FileAccess.open(READ_FROM, FileAccess.READ)

	if file == null:
		print("Failed to open file.")
		return output

	# Read the file line by line
	while not file.eof_reached():
		var line: String = file.get_line().strip_escapes()

		# Check if the line contains a color definition
		if not line.begins_with("**"):
			continue

		var color_name: String = substr_between(line, "**", "**")
		var color_values: PackedStringArray = substr_between(line, "(", ")").split(",")

		var color: Color = Color(
			color_values[0].to_float(),
			color_values[1].to_float(),
			color_values[2].to_float(),
			color_values[3].to_float()
		)

		output.append(ColorPair.new(format_name(color_name), color))

	file.close()

	output.sort_custom(color_comparer)
	return output

# 1. To lower case
# 2. Replace underscores with spaces
func format_name(name: String) -> String:
	return name
	return name.to_lower().replace("_", "")

## Returns the substring between the first occurrence of opener and the last occurrence of closer
func substr_between(text: String, opener: String, closer: String) -> String:
	var start = text.find(opener)
	if start == -1:
		return ""

	start += opener.length()  # Move start to the end of the opener

	# Use rfind() to find the last occurrence of closer
	var end = text.rfind(closer)
	if end == -1 or end <= start:
		return ""

	return text.substr(start, end - start)


## Compares two colors and returns true if the first color is "smaller" than the second
func color_comparer(a: ColorPair, b: ColorPair) -> bool:
	if a.color == Color.TRANSPARENT:
		return false

	if b.color == Color.TRANSPARENT:
		return true

	return color_to_value(a.color) < color_to_value(b.color)


## Converts a color to a "value" that can be used for sorting
## More info at https://www.alanzucconi.com/2015/09/30/colour-sorting/
func color_to_value(color: Color) -> Vector3:
	var repetitions: int = 8
	var lum: float = sqrt(0.241 * color.r + 0.691 * color.g + 0.068 * color.b)

	var hsv: Color = rgb_to_hsv(color)
	var h: float = hsv.r
	var v: float = hsv.b

	var h2: int = int(h * repetitions)
	var lum2: int = int(lum * repetitions)
	var v2: int = int(v * repetitions)

	# if h2 % 2 == 1:
	# 	v2 = repetitions - v2
	# 	lum = repetitions - lum

	return Vector3(h2, lum2, v2)


## Converts a color from RGB to HSV
## R = Hue, G = Saturation, B = Value
func rgb_to_hsv(color: Color) -> Color:
	var c_max = max(color.r, max(color.g, color.b))
	var c_min = min(color.r, min(color.g, color.b))
	var delta = c_max - c_min
	var h = 0.0
	var s = 0.0
	var v = c_max

	if delta != 0.0:
		s = delta / c_max
		if color.r == c_max:
			h = (color.g - color.b) / delta
		elif color.g == c_max:
			h = 2.0 + (color.b - color.r) / delta
		else:
			h = 4.0 + (color.r - color.g) / delta
		h /= 6.0
		if h < 0.0:
			h += 1.0

	return Color(h, s, v)
