import Quickshell
import QtQuick
import Quickshell.Hyprland

import qs.config
import qs.components

Rectangle {
  id: root

  required property var screen
  readonly property var monitor: Hyprland.monitorFor(root.screen)
  readonly property var workspaces: {
    const list = Hyprland.workspaces.values.filter(w => w.id > 0 && w.monitor === root.monitor)

    list.sort((a, b) => a.id - b.id)
    return list
  }
  readonly property int activeIndex: workspaces.findIndex(w => w.active)

  property int cellWidth: 28
  property int padding: 5
  property int thumbSize: 18

  implicitWidth: 2 * padding + cellWidth * workspaces.length
  implicitHeight: Theme.moduleHeight

  radius: Theme.radius
  color: Colors.bg1
  visible: workspaces.length > 0

  Shadow {}

  Rectangle {
    anchors.verticalCenter: parent.verticalCenter
    x: root.padding + root.cellWidth * root.activeIndex + (root.cellWidth - root.thumbSize) / 2
    width: root.thumbSize
    height: root.thumbSize
    radius: root.thumbSize / 2

    visible: root.activeIndex >= 0
    color: Colors.tint(Colors.accent)

    Behavior on x { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }
  }

  Row {
    x: root.padding
    height: parent.height

    Repeater {
      model: root.workspaces

      Item {
        id: cell

        required property var modelData

        readonly property bool busy: modelData.toplevels.values.length > 0

        width: root.cellWidth
        height: parent.height

        Rectangle {
          anchors.centerIn: parent
          width: {
            if (indicatorMouse.containsMouse) return 11
            return parent.busy || parent.modelData.active ? 8 : 6
          }
          height: width
          radius: width / 2

          Behavior on width { NumberAnimation { duration: Theme.hoverTime; easing.type: Easing.OutCubic } }

          color: {
            if (parent.modelData.urgent) return Colors.yellow
            if (parent.modelData.active) return Colors.accent
            if (parent.busy) return Colors.fg
            return Colors.bg3
          }

          Behavior on color { ColorAnimation { duration: 200 } } 
        }

        MouseArea {
          id: indicatorMouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: cell.modelData.activate()
        }
      }
    }
  }
}
