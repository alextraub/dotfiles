pragma Singleton
import Quickshell
import QtQuick

Singleton {
  id: root

  readonly property int moduleHeight: 30
  readonly property int spacing: 8 
  readonly property int margin: 13
  readonly property int radius: 15
  readonly property int belowBar: 2 * margin + moduleHeight
  readonly property int panelWidth: 360
  readonly property int panelRadius: 20
  readonly property int shadowRoom: 24

  readonly property string font: "JetBrainsMono Nerd Font Propo"
  readonly property var iconFonts: ({
    "rounded": "Material Symbols Rounded",
    "outlined": "Material Symbols Outlined",
    "sharp": "Material Symbols Sharp"
  })

  readonly property int txtMd: 15
  readonly property int txtSm: 13
  readonly property int txtXs: 11
  readonly property int iconSize: 16

  readonly property var iconAxes: ({ "FILL": 0, "wght": 700, "GRAD": 0, "opsz": 20 })
  readonly property var iconAxesFilled: ({ "FILL": 1, "wght": 600, "GRAD": 0, "opsz": 20 })

  readonly property int slideTime: 360
  readonly property int fadeTime: 220
  readonly property int hoverTime: 140
}
