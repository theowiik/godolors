extends CenterContainer
class_name ColorCard

onready var rect: ColorRect = $ColorRect
onready var label: Label = $Label

func set_color(color: Color) -> void:
  if color == null: return
  rect.color = color

func set_text(msg: String) -> void:
  if msg == null: return
  label.text = msg
