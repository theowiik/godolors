extends Node2D

# ====== CONFIG ======

const SAVE_TO: String = "user://colors.png"
const READ_FROM: String = "res://_INPUT_COLORS_HERE.txt"

const CARD_WIDTH: int = 430
const CARD_HEIGHT: int = 70
const COLUMNS: int = 7

# ====================

@onready var card_container: GridContainer = $CardContainer
@onready var color_card: PackedScene = preload("res://scenes/color_card.tscn")
var screenshot_taken: bool = false


class ColorPair:
	var name: String
	var color: Color

	func _init(_name: String, _color: Color):
		name = _name
		color = _color


func _ready() -> void:
	add_cards(parse_colors())
	card_container.columns = COLUMNS


func _process(_delta) -> void:
	if screenshot_taken:
		return

	get_window().size = card_container.size
	await get_tree().physics_frame
	screenshot()
	screenshot_taken = true


func screenshot() -> void:
	var img: Image = get_viewport().get_texture().get_image()
	img.save_png(SAVE_TO)
	var path: String = ProjectSettings.globalize_path("user://")
	OS.shell_open(path)


func add_cards(colors: Array[ColorPair]) -> void:
	for colorPair in colors:
		var card: ColorCard = color_card.instantiate()
		card_container.add_child(card)
		card.set_text(colorPair.name)
		card.set_color(colorPair.color)
		card.set_card_size(CARD_WIDTH, CARD_HEIGHT)


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
	return output


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
