pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  readonly property string time: Qt.formatDateTime(clock.date, "HH:mm")
  readonly property string date: Qt.formatDateTime(clock.date, "yyyy-MM-dd")
}
