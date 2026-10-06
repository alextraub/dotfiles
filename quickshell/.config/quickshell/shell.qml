import Quickshell
import QtQuick

import qs.modules.status_bar

ShellRoot {
  id: root

  Variants {
    model: Quickshell.screens

    Scope {
      id: self
      required property var modelData

      StatusBar { screen: self.modelData }
    }
  }
  
  IpcWrapper {}
}
