import Quickshell
import QtQuick
import qs.config
import qs.components
import qs.services

PanelWindow {
  id: statusBar

  // True on whichever screen currently has the "main" role, follows SUPER + X swaps
  readonly property bool isMain: Displays.isMain(screen)

  anchors { top: true; left: true; right: true }
  margins { top: Theme.margin; left: Theme.margin; right: Theme.margin }


  implicitHeight: Theme.moduleHeight + Theme.shadowRoom
  exclusiveZone: Theme.moduleHeight
  color: "transparent"
  

  Row {
    anchors.left: parent.left
    anchors.leftMargin: Theme.spacing
    spacing: Theme.spacing

    LauncherButton {}
    MediaPill {}
  }

  Row {
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: Theme.spacing
    
    ClockPill {}
    Workspaces { screen: statusBar.screen }
  }

  Row {
    anchors.right: parent.right
    anchors.rightMargin: Theme.spacing
    spacing: Theme.spacing

    NetworkPill {}
    VolumePill {}
  }
}
