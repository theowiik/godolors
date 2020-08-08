extends Node
class_name ColorFileReader

const file_name: String = "colors.txt"

# Returns a dictionary like { "blue": ColorObjectHere }
func get_colors() -> Dictionary:
  var output: Dictionary = {}

  var file: File = File.new()
  assert(file.file_exists(file_name))
  file.open(file_name, File.READ)

  while not file.eof_reached():
    var line: String = file.get_line()
    var color_name: String = line.split(" ")[0]
    var regex: RegEx = RegEx.new()
    regex.compile("\\( .* \\)")
    var result: RegExMatch = regex.search(line)
    var colorStr: String = result.strings[0].replace("(", "").replace(")", "").replace(" ", "")
    var splitted: Array = colorStr.split(",")
    output[color_name] = Color(float(splitted[0]), float(splitted[1]), float(splitted[2]), float(splitted[3]))

  file.close()

  return output
