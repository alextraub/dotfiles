import Quickshell
import Quickshell.Io
import qs.services

Scope {
  IpcHandler {
    target: "launcher"

    function open(): void {
      PopupService.openLauncher()
    }

    function close(): void {
      PopupService.closeLauncher()
    }

    function toggle(): void {
      PopupService.toggleLauncher()
    }

    function isOpen(): bool {
      return PopupService.launcherOpen
    }
  }
}
