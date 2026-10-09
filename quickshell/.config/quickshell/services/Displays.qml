pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Hyprland

// Which screen is "main" and which is "side". Hyprland's modules/roles.lua writes
// this file at startup and whenever SUPER + X swaps the monitors.
Singleton {
  id: root

  property string main: ""
  property string side: ""

  function isMain(screen) { return screen != null && screen.name === main }

  function _parse(text) {
    try {
      const state = JSON.parse(text)
      main = state.main ?? ""
      side = state.side ?? ""
    } catch (e) {
      // Caught mid-write; the next change event brings the full file
    }
  }

  FileView {
    path: (Quickshell.env("XDG_STATE_HOME") || Quickshell.env("HOME") + "/.local/state") + "/hypr/monitor-roles.json"
    watchChanges: true
    printErrors: false

    onFileChanged: reload()
    onLoaded: root._parse(text())
  }

  property string targetName: Quickshell.screens[0].name

  function syncTarget() {
    const focused = Hyprland.focusedMonitor

    targetName = focused != null ? focused.name : Quickshell.screens[0].name
  }

  Component.onCompleted: syncTarget()
}
