using System.Linq;
using Godot;
using Godot.Collections;

public sealed class ColorRetriever : Node
{
  private const string FileName = "colors.txt";

  public Array<Dictionary<string, Color>> GetSortedColors()
  {
    var colors = ParseFile();
    return Sorted(colors);
  }

  private Array<Dictionary<string, Color>> Sorted(Array<Dictionary<string, Color>> colors)
  {
    var godotArr = new Array<Dictionary<string, Color>>();
    var sorted   = colors.OrderBy(dic => dic[dic.Keys.First()].h);

    foreach (var dic in sorted)
      godotArr.Add(dic);

    return godotArr;
  }

  private Array<Dictionary<string, Color>> ParseFile()
  {
    var output = new Array<Dictionary<string, Color>>();

    var file = new File();
    file.Open(FileName, File.ModeFlags.Read);

    while (!file.EofReached())
    {
      var line      = file.GetLine();
      var colorName = line.Split(" ")[0];
      var regex     = new RegEx();
      regex.Compile("\\( .* \\)");
      var result          = regex.Search(line);
      var colorStr        = result.Strings[0] as string;
      var cleanedColorStr = colorStr.Replace("(", "").Replace(")", "").Replace(" ", "");
      var splitted        = cleanedColorStr.Split(",");

      var dic = new Dictionary<string, Color>
      {
        [colorName] = new Color(
          float.Parse(splitted[0]),
          float.Parse(splitted[1]),
          float.Parse(splitted[2]),
          float.Parse(splitted[3])
        )
      };

      output.Add(dic);
    }

    return output;
  }
}