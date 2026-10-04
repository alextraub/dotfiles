pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Mpris

import "../util.js" as Util
import "../assert.js" as Assert

Singleton {
  id: root

  readonly property var players: Mpris.players.values

  // The player that most recently started playing, so pausing doesn't make
  // the active player jump to some other idle one.
  property var _lastPlaying: null

  // Priority: playing > last playing (if still around) > first player
  readonly property var player: players.find(p => p.isPlaying)
    ?? (players.includes(_lastPlaying) ? _lastPlaying : null)
    ?? players[0]
    ?? null

  readonly property bool ready: player != null
  readonly property bool playing: ready && player.isPlaying

  onPlayerChanged: if (playing) _lastPlaying = player
  onPlayingChanged: if (playing) _lastPlaying = player

  readonly property string title: ready ? player.trackTitle : ""
  readonly property string artist: ready ? player.trackArtist : ""
  // player.trackArtists is just an alias for trackArtist, so read the list
  // from the raw metadata, dropping the empty entries some players send.
  readonly property var artists: ready
    ? (player.metadata["xesam:artist"] ?? []).filter(a => a !== "")
    : []
  readonly property string album: ready ? player.trackAlbum : ""
  readonly property string albumArtist: ready ? player.trackAlbumArtist : ""
  readonly property string artUrl: ready ? player.trackArtUrl : ""
  readonly property string identity: ready ? player.identity : ""
  readonly property string desktopEntry: ready ? player.desktopEntry : ""

  // In seconds
  readonly property real position: ready && player.positionSupported ? player.position : 0
  readonly property real length: ready && player.lengthSupported ? player.length : 0
  readonly property real progress: length > 0 ? Util.clamp(position / length, 0, 1) : 0

  readonly property bool canTogglePlaying: ready && player.canTogglePlaying
  readonly property bool canGoNext: ready && player.canGoNext
  readonly property bool canGoPrevious: ready && player.canGoPrevious
  readonly property bool canSeek: ready && player.canSeek

  // MPRIS doesn't push position updates while playing, so poke the player to
  // re-read its position.
  Timer {
    running: root.playing && root.player.positionSupported
    interval: 1000
    repeat: true
    onTriggered: root.player.positionChanged()
  }

  function togglePlaying() {
    if (!canTogglePlaying) return
    player.togglePlaying()
  }

  function next() {
    if (!canGoNext) return
    player.next()
  }

  function previous() {
    if (!canGoPrevious) return
    player.previous()
  }

  function setPosition(seconds) {
    if (!canSeek) return
    player.position = Util.clamp(Assert.ensureNumber(seconds), 0, length)
  }

  function setProgress(fraction) {
    setPosition(Assert.ensureNumber(fraction) * length)
  }
}
