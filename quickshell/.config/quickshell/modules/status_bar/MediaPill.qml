import QtQuick
import qs.config
import qs.services
import qs.components

import "../../components/icons/iconSets.js" as IconSets

Pill {
  visible: Media.ready
  icon: IconSets.media.select(Media.playing ? "playing" : "paused")
  iconFilled: true
  iconVariant: "sharp"
  accent: Colors.purple
  text: Media.title || Media.identity
  maxTextWidth: 220
}
