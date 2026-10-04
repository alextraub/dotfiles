pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Networking

Singleton {
  id: root

  readonly property bool wifiEnabled: Networking.wifiEnabled
  readonly property var devices: Networking.devices.values
  readonly property var wiredDevices: devices.filter(d => d.type === DeviceType.Wired)
  readonly property var wifiDevices: devices.filter(d => d.type === DeviceType.Wifi)

  // Priority: connected ethernet > connected wifi > any wifi > any ethernet
  readonly property var device: wiredDevices.find(d => d.connected)
    ?? wifiDevices.find(d => d.connected)
    ?? wifiDevices[0]
    ?? wiredDevices[0]
    ?? null

  readonly property bool isWifi: device != null && device.type === DeviceType.Wifi

  readonly property bool connected: device != null && device.connected

  // The network the device is connected to, or null
  readonly property var network: device != null
    ? device.networks.values.find(n => n.connected) ?? null
    : null

  readonly property string networkName: network != null ? network.name : ""
  readonly property real signalStrength: isWifi && network != null ? network.signalStrength : 0
}
