import QtQuick
import qs.config
import qs.components.icons

Rectangle {
  id: button

  property string icon: ""
  property color accent: Colors.fg
  property int size: Theme.moduleHeight
  property bool shadow: true

  readonly property bool hovered: ma.containsMouse

  signal clicked()
  
  width: size
  height: size
  radius: size / 2

  color: Qt.tint(hovered ? Colors.bg3 : Colors.bg1, Colors.tint(accent))
  scale: hovered ? 1.1 : 1

  Behavior on color {
    ColorAnimation { duration: Theme.hoverTime }
  }
  Behavior on scale {
    NumberAnimation { duration: Theme.hoverTime; easing.type: Easing.OutCubic }
  }

  Shadow { visible: button.shadow }

  Icon {
    anchors.centerIn: parent
    name: button.icon
    color: button.accent
    size: Math.round(0.53 * button.size)
  }


  MouseArea {
    id: ma
    anchors.fill: parent

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: button.clicked()
  }
}
