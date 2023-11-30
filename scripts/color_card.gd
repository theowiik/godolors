extends CenterContainer
class_name ColorCard

@onready var rect: ColorRect = $ColorRect
@onready var label: Label = $Label


func set_color(color: Color) -> void:
	rect.color = color


func set_text(msg: String) -> void:
	label.text = msg


func set_card_size(width: int, height: int) -> void:
	var cardMinSize: Vector2 = Vector2(width, height)
	custom_minimum_size = cardMinSize
	rect.custom_minimum_size = cardMinSize
