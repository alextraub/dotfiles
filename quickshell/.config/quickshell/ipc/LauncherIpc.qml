import Quickshell
import Quickshell.Io
import qs.services

IpcHandler {
  target: "launcher"

  function open(): void {
    LauncherService.openLauncher()
  }

  function close(): void {
    LauncherService.closeLauncher()
  }

  function toggle(): void {
    LauncherService.toggleLauncher()
  }

  function isOpen(): bool {
    return LauncherService.launcherOpen
  }
}
