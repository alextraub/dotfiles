import QtQuick
import qs.config

// Text capped at maxWidth (0 = no cap). Overflowing text is elided, and while
// scrolling is true it loops through as a ticker instead.
Item {
  id: marquee

  property string text: ""
  property color color: Colors.fg
  property alias font: measure.font
  property int maxWidth: 0
  property bool scrolling: false
  property real speed: 40   // px per second
  property int gap: 40      // px between the end of the text and its repeat
  property int pause: 1000  // ms held at the start of each loop

  readonly property bool overflowing: maxWidth > 0 && measure.implicitWidth > maxWidth
  readonly property bool ticking: scrolling && overflowing
  readonly property real loopWidth: measure.implicitWidth + gap

  implicitWidth: overflowing ? maxWidth : measure.implicitWidth
  implicitHeight: measure.implicitHeight
  clip: true

  // When scrolling stops mid-loop, ease to the nearer loop point (both look
  // identical) instead of snapping back to the start.
  onTickingChanged: {
    if (ticking || ticker.x === 0) return
    settle.to = ticker.x < -loopWidth / 2 ? -loopWidth : 0
    settle.start()
  }

  Text {
    width: marquee.width
    visible: !ticker.visible
    text: marquee.text
    color: marquee.color
    font: measure.font
    elide: Text.ElideRight
  }

  // Two copies one gap apart: scrolling by one copy's width plus the gap lands
  // on a frame identical to the start, so the loop is seamless.
  Row {
    id: ticker
    visible: marquee.ticking || settle.running
    spacing: marquee.gap

    Text {
      id: measure
      text: marquee.text
      color: marquee.color
    }

    Text {
      text: marquee.text
      color: marquee.color
      font: measure.font
    }
  }

  SequentialAnimation {
    // Waits for a settle to finish so it always starts from x = 0
    running: marquee.ticking && !settle.running
    loops: Animation.Infinite

    PauseAnimation { duration: marquee.pause }
    NumberAnimation {
      target: ticker
      property: "x"
      from: 0
      to: -marquee.loopWidth
      duration: 1000 * marquee.loopWidth / marquee.speed
    }
  }

  NumberAnimation {
    id: settle
    target: ticker
    property: "x"
    duration: Theme.slideTime
    easing.type: Easing.OutCubic
    onFinished: ticker.x = 0
  }
}
