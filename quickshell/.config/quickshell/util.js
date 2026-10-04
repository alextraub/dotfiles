.pragma library

function asPercentLabel(val) {
  return Math.round(100 * val) + "%"
}

function clamp(val, min, max) {
  return Math.min(Math.max(val, min), max)
}

// options[level], with level truncated and clamped so the last entry covers
// everything above it. Booleans work as levels: pick([off, on], cond).
function pick(options, level) {
  return options[clamp(Math.trunc(level), 0, options.length - 1)]
}

// options[n] where n is how many ascending thresholds value has reached, so
// options needs thresholds.length + 1 entries:
//   pickByThreshold(0.4, [0.2, 0.5, 0.8], [empty, low, mid, full])  // low
function pickByThreshold(value, thresholds, options) {
  let level = 0
  while (level < thresholds.length && value >= thresholds[level]) level++
  return pick(options, level)
}

// options[key] for named states, or fallback when the key is missing:
//   pickByKey({ charging: "bolt", full: "battery_full" }, state, "battery_std")
function pickByKey(options, key, fallback) {
  return options[key] ?? fallback
}
