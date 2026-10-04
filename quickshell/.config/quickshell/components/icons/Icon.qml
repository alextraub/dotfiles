import QtQuick
import qs.config

Text {
  property string name: ""
  property int size: Theme.iconSize
  property bool filled: false

  text: name
  color: Colors.fg 
  font.family: Theme.iconFont
  font.pixelSize: size

  font.variableAxes: filled ? Theme.iconAxesFilled : Theme.iconAxes
}
