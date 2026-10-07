import QtQuick

import qs.services
import qs.components
import qs.config

RoundButton {
  accent: Colors.accent
  onClicked: LauncherService.toggleLauncherCentered()
  icon: "rocket_launch" 
}
