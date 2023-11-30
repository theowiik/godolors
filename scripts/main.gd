extends Node2D

# ====== CONFIG ======

const SAVE_TO: String = "user://colors.png"
const CARD_WIDTH: int = 430
const CARD_HEIGHT: int = 70
const COLUMNS: int = 7

# ====================

const ColorParser = preload("res://scripts/color_parser.gd")
const ColorPair = preload("res://scripts/color_parser.gd")
@onready var card_container: GridContainer = $CardContainer
@onready var color_card: PackedScene = preload("res://scenes/color_card.tscn")
var screenshot_taken: bool = false


func _ready() -> void:
	var colorParser: ColorParser = ColorParser.new()
	add_cards(colorParser.parse_colors())
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


func add_cards(colors: Array[ColorParser.ColorPair]) -> void:
	for colorPair in colors:
		var card: ColorCard = color_card.instantiate()
		card_container.add_child(card)
		card.set_text(colorPair.name)
		card.set_color(colorPair.color)
		card.set_card_size(CARD_WIDTH, CARD_HEIGHT)
