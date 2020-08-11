extends Node2D

onready var card_container: GridContainer = $CardContainer
onready var color_card: PackedScene = preload("res://scenes/ColorCard.tscn")
const COLUMNS: int = 5
const CARD_WIDTH: int = 200
const CARD_HEIGHT: int = 32
var screenshot_taken: bool = false

func _ready():
  var colors = get_colors()
  add_cards(colors)
  set_columns(COLUMNS)

func _process(_delta) -> void:
  if !screenshot_taken:
    set_window_size()
    yield(get_tree(), "idle_frame")
    screenshot()
    screenshot_taken = true

func screenshot() -> void:
  var img: Image = get_viewport().get_texture().get_data()

  var filePath: String = "user://colors.png";
  img.flip_y();
  img.save_png(filePath);

  var path: String = ProjectSettings.globalize_path("user://");
  OS.shell_open(path)

func get_colors() -> Dictionary:
  var cs_class = preload("res://scripts/ColorRetriever.cs")
  var cs_node = cs_class.new()
  return cs_node.GetSortedColors()

func add_cards(colors: Array) -> void:
  for colorDic in colors:
    var colorName: String = colorDic.keys()[0]
    var color: Color = colorDic[colorName]
    
    var card: ColorCard = color_card.instance()
    card_container.add_child(card)
    card.set_text(colorName)
    card.set_color(color)
    card.set_card_size(CARD_WIDTH, CARD_HEIGHT)

func set_columns(n: int) -> void:
  if n <= 0: return
  card_container.columns = n

func set_window_size() -> void:
  OS.window_size = card_container.rect_size
