extends Node2D

onready var card_container: GridContainer = $CardContainer
onready var color_card: PackedScene = preload("res://scenes/ColorCard.tscn")
const COLUMNS: int = 4
const CARD_WIDTH: int = 64
const CARD_HEIGHT: int = 128

func _ready():
  var dic: Dictionary = get_color_hex_dic()
  add_cards(dic)
  set_columns(COLUMNS)

func _process(delta):
  set_window_size() # should not be here :), but I am probably not gonna fix it

func get_color_hex_dic() -> Dictionary:
  return {"blue": "#0000ff", "red": "#ff0000"}

func add_cards(colors: Dictionary) -> void:
  for key in colors.keys():
    var hexCode: String = colors[key]
    
    var card: ColorCard = color_card.instance()
    card_container.add_child(card)
    card.set_text(key)
    card.set_color_hex(hexCode)
    card.set_card_size(CARD_WIDTH, CARD_HEIGHT)

func set_columns(n: int) -> void:
  if n <= 0: return
  card_container.columns = n

func set_window_size() -> void:
  OS.window_size = card_container.rect_size
