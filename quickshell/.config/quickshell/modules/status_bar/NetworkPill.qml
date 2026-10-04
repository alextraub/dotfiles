import QtQuick
import qs.config
import qs.services
import qs.components

import "../../components/icons/iconSets.js" as IconSets

Pill {
  icon: Network.isWifi
    ? IconSets.wifi.select(Network.signalStrength, { disabled: !Network.wifiEnabled, disconnected: !Network.connected })
    : IconSets.wired.select(null, { disconnected: !Network.connected })
  accent: Colors.aqua
}
