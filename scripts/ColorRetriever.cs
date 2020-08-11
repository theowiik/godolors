using Godot;
using System;
using System.Collections.Generic;
using Godot.Collections;

public class ColorRetriever : Node
{
  public Array<Godot.Collections.Dictionary<string, Color>> GetSortedColors()
  {
    return new Array<Godot.Collections.Dictionary<string, Color>>
    {
      new Godot.Collections.Dictionary<string, Color>
      {
        ["blue"] = new Color(0, 0, 1)
      }
    };
  }
}
