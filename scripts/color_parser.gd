const READ_FROM: String = "res://_INPUT_COLORS_HERE.txt"


class ColorPair:
	var name: String
	var color: Color

	func _init(_name: String, _color: Color):
		name = _name
		color = _color


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

		output.append(ColorPair.new(color_name, color))

	file.close()

	return sorted(output)


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


func sorted(colors: Array[ColorPair]) -> Array[ColorPair]:
	# Convert RGB colors to HSV and sort by hue
	var hsv_colors = []
	for color_pair in colors:
		var hsv = rgb_to_hsv(color_pair.color)
		hsv_colors.append({"hsv": hsv, "pair": color_pair})

	hsv_colors.sort_custom(compare_hue)

	var sorted_colors: Array[ColorPair] = []
	for item in hsv_colors:
		sorted_colors.append(item.pair)

	return sorted_colors


func compare_hue(a, b):
	return a.hsv.r < b.hsv.r


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
