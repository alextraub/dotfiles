.pragma library
  .import "../../util.js" as Util

// Factories for icon selectors. Each returns a frozen { select } object; define
// shared sets as consts below and call .select() in bindings:
//   icon: IconSets.volume.select(Audio.volume, { muted: Audio.muted })
//
// overrides maps flag names to an icon or another selector. select(input, flags)
// uses the first override, in declaration order, whose flag is truthy: an icon
// is returned as is, a selector picks from input with its own rules. Otherwise
// the normal selection applies.

function _selector(overrides, pickIcon) {
  const entries = Object.entries(overrides ?? {})
  return Object.freeze({
    select(input, flags) {
      if (flags) {
        for (const [flag, icon] of entries) {
          if (flags[flag]) return typeof icon === "string" ? icon : icon.select(input, flags)
        }
      }
      return pickIcon(input)
    }
  })
}

// select(value): icons[n] for the n ascending thresholds value has reached.
// icons needs thresholds.length + 1 entries.
function byThreshold(thresholds, icons, overrides) {
  return _selector(overrides, value => Util.pickByThreshold(value, thresholds, icons))
}

// select(key): icons[key], or fallback for unknown keys.
function byKey(icons, fallback, overrides) {
  return _selector(overrides, key => Util.pickByKey(icons, key, fallback))
}

const volume = byThreshold([0.01, 0.5], ["volume_mute", "volume_down", "volume_up"], { muted: "volume_off" })
