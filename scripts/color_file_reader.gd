extends Node
class_name ColorFileReader

const file_name: String = "colors.txt"

func get_colors() -> Dictionary:
  var output: Dictionary = {}

  var file: File = File.new()
  assert(file.file_exists(file_name))
  file.open(file_name, File.READ)

  while not file.eof_reached():
    var line: String = file.get_line()

  file.close()

  output["blue"] = "#0000ff"

  return output
