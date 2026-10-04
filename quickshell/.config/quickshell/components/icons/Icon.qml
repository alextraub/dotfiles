import QtQuick
import qs.config

Text {
  property string name: ""
  property int size: Theme.iconSize
  property bool filled: false
  property string variant: "rounded"  // a key of Theme.iconFonts

  text: name
  color: Colors.fg
  // The default distance-field renderer leaves holes where the variable font's
  // filled outlines overlap; FreeType fills them properly.
  renderType: Text.NativeRendering
  font.family: Theme.iconFonts[variant] ?? Theme.iconFonts.rounded
  font.pixelSize: size

  font.variableAxes: filled ? Theme.iconAxesFilled : Theme.iconAxes
}
