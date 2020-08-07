extends Node2D

onready var card_container: ItemList = $CardContainer
onready var color_card: PackedScene = preload("res://scenes/ColorCard.tscn")

func _ready():
  var dic: Dictionary = {"blue": "#0000ff", "red": "#ff0000"}
  add_cards(dic)

func add_cards(colors: Dictionary) -> void:
  for colorKey in colors.keys():
    var hexCode: String = colors[colorKey]
    
    var card: ColorCard = color_card.instance()
    card_container.add_child(card)
    card.set_text(colorKey)
