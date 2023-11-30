extends Node2D

# ====== CONFIG ======

var filePath: String = "user://colors.png"
const CARD_WIDTH: int = 230
const CARD_HEIGHT: int = 40
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
	add_cards(get_colors())
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
	img.save_png(filePath)
	var path: String = ProjectSettings.globalize_path("user://")
	OS.shell_open(path)


func add_cards(colors: Array[ColorPair]) -> void:
	for colorPair in colors:
		var card: ColorCard = color_card.instantiate()
		card_container.add_child(card)
		card.set_text(colorPair.name)
		card.set_color(colorPair.color)
		card.set_card_size(CARD_WIDTH, CARD_HEIGHT)


func get_colors() -> Array[ColorPair]:
	var output: Array[ColorPair] = []

	output.append(ColorPair.new("AliceBlue", Color(0.941176, 0.972549, 1.000000)))
	output.append(ColorPair.new("AntiqueWhite", Color(0.980392, 0.921569, 0.843137)))

	return output
