.pragma library

// Lightweight argument assertions.
//
//   assert*(val, ..., opts)  check only, no return value
//   ensure*(val, ..., opts)  check and return val, for inline use:
//                              const vol = Assert.ensureInRange(v, 0, 1)
//
// opts is optional: { msg, fallbackCb }. A failure throws unless fallbackCb is
// given, in which case it warns and calls fallbackCb(val); ensure* returns that
// result in place of val.

function _describe(val) {
  if (val === null) return "null"
  if (Array.isArray(val)) return "array"
  if (Number.isNaN(val)) return "NaN"
  return typeof val
}

function _fail(defaultMsg, { msg, fallbackCb } = {}, val) {
  const logMsg = `[Assert failed] ${msg ?? defaultMsg}`
  if (!fallbackCb) throw new Error(logMsg)
  console.warn(logMsg)
  return fallbackCb(val)
}

function _check(ok, val, expected, opts) {
  return ok ? val : _fail(`Expected ${expected}, got ${_describe(val)}`, opts, val)
}

function assert(condition, opts) {
  if (!condition) _fail("Assertion failed.", opts, condition)
}

function ensureDefined(val, opts) {
  return _check(val != null, val, "a defined value", opts)
}

function ensureNumber(val, opts) {
  return _check(typeof val === "number" && !Number.isNaN(val), val, "number", opts)
}

function ensureInt(val, opts) {
  return _check(Number.isInteger(val), val, "integer", opts)
}

function ensureString(val, opts) {
  return _check(typeof val === "string", val, "string", opts)
}

function ensureBool(val, opts) {
  return _check(typeof val === "boolean", val, "boolean", opts)
}

function ensureFunction(val, opts) {
  return _check(typeof val === "function", val, "function", opts)
}

function ensureObject(val, opts) {
  return _check(typeof val === "object" && val !== null && !Array.isArray(val), val, "object", opts)
}

function ensureArray(val, opts) {
  return _check(Array.isArray(val), val, "array", opts)
}

function ensureInRange(val, min, max, opts) {
  return typeof val === "number" && val >= min && val <= max
    ? val
    : _fail(`Expected number in [${min}, ${max}], got ${val}`, opts, val)
}

function ensureOneOf(val, options, opts) {
  return options.includes(val)
    ? val
    : _fail(`Expected one of [${options.join(", ")}], got ${val}`, opts, val)
}

function ensureInstanceOf(val, ctor, opts) {
  return _check(val instanceof ctor, val, ctor.name || "instance", opts)
}

function assertDefined(val, opts) { ensureDefined(val, opts) }
function assertNumber(val, opts) { ensureNumber(val, opts) }
function assertInt(val, opts) { ensureInt(val, opts) }
function assertString(val, opts) { ensureString(val, opts) }
function assertBool(val, opts) { ensureBool(val, opts) }
function assertFunction(val, opts) { ensureFunction(val, opts) }
function assertObject(val, opts) { ensureObject(val, opts) }
function assertArray(val, opts) { ensureArray(val, opts) }
function assertInRange(val, min, max, opts) { ensureInRange(val, min, max, opts) }
function assertOneOf(val, options, opts) { ensureOneOf(val, options, opts) }
function assertInstanceOf(val, ctor, opts) { ensureInstanceOf(val, ctor, opts) }
