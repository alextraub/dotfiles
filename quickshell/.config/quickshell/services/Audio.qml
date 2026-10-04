pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Pipewire

import "../util.js" as Util
import "../assert.js" as Assert

Singleton {
  id: root
  PwObjectTracker { objects: [Pipewire.defaultAudioSink] }
  
  readonly property real maxVolume: 1.0
  readonly property var sink: Pipewire.defaultAudioSink
  readonly property bool ready: sink != null && sink.audio != null
  readonly property real volume: !ready ? 0 : sink.audio.volume
  readonly property bool muted: !ready ? false : sink.audio.muted

  function setVolume(newVolume) {
    if (!ready) return
    const safeVolume = Util.clamp(Assert.ensureNumber(newVolume), 0, maxVolume)
    
    sink.audio.volume = safeVolume
  }

  function toggleMute() {
    if (!ready) return
    sink.audio.muted = !sink.audio.muted
  }
}
