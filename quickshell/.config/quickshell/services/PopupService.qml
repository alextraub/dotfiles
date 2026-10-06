pragma Singleton
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick

Singleton {
  id: root

  // Must match CLASS in hypr/modules/launcher.lua
  readonly property string launcherAppId: "vicinae"

  // Read from the window list instead of tracked here, so it can't drift from Hyprland: the
  // launcher counts as open exactly while its window exists, however it was opened or closed
  // (keybind, clicking another window, Esc, this shell)
  readonly property bool launcherOpen: ToplevelManager.toplevels.values.some(t => t.appId === launcherAppId)

  // Runs a function from hypr/modules/launcher.lua. Hyprland's dispatch calls a Lua function
  // it is handed, so the guards and behavior there apply the same as for the keybind
  function launcherCall(name) {
    Hyprland.dispatch(`require("modules.launcher").${name}`)
  }

  function openLauncher() { launcherCall("open") }
  function closeLauncher() { launcherCall("close") }
  function toggleLauncher() { launcherCall("toggle") }
  // Opens in the middle of the cursor's monitor rather than at the cursor
  function toggleLauncherCentered() { launcherCall("toggle_centered") }

  function closeAll() {
    closeLauncher()
  }
}
