import QtQuick
import qs.config

Rectangle {
  id: pill

  property string icon: ""
  property bool iconFilled: false
  property string iconVariant: "rounded"
  property color accent: Colors.fg
  property string text: ""
  property int maxTextWidth: 0  // 0 = no cap; longer text scrolls on hover

  readonly property bool hovered: hover.hovered

  implicitWidth: row.width
  implicitHeight: Theme.moduleHeight
  radius: Theme.radius
  color: Colors.bg1

  Shadow {}

  HoverHandler { id: hover }

  Row {
    id: row

    height: parent.height
    leftPadding: 4
    rightPadding: label.visible ? 12 : 4
    spacing: 10

    IconDisc {
      anchors.verticalCenter: parent.verticalCenter
      icon: pill.icon
      filled: pill.iconFilled
      variant: pill.iconVariant
      accent: pill.accent
      size: 22
    }

    MarqueeText {
      id: label
      anchors.verticalCenter: parent.verticalCenter
      visible: pill.text !== ""
      text: pill.text
      maxWidth: pill.maxTextWidth
      scrolling: pill.hovered
      color: Colors.fg
      font.family: Theme.font
      font.pixelSize: Theme.txtMd
      font.weight: 600
    }
  }
}
