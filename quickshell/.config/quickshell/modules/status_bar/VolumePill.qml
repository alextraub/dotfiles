import QtQuick
import qs.config
import qs.services
import qs.components

import "../../components/icons/iconSets.js" as IconSets

Pill {
  icon: IconSets.volume.select(Audio.volume, { muted: Audio.muted })
  accent: Colors.blue
  text: Util.asPercentLabel(Audio.volume)
}
