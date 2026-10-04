import QtQuick
import qs.config
import qs.components.icons

Rectangle {
  id: disc

  property string icon: ""
  property color accent: Colors.accent
  property int size: Theme.moduleHeight
  property bool filled: false
  property string variant: "rounded"

  width: size
  height: size
  radius: size / 2
  color: Colors.tint(accent)

  Icon {
    anchors.centerIn: parent
    name: disc.icon
    filled: disc.filled
    variant: disc.variant
    color: disc.accent
    size: Math.round(0.53 * disc.size)
  }
}
