import QtQuick
import QtQuick.Effects
import qs.config

RectangularShadow {
  anchors.fill: parent
  z: -1

  radius: parent.radius
  blur: 16
  spread: 1
  offset: Qt.vector2d(0, 3)
  color: Qt.rgba(0, 0, 0, 0.45)
}
