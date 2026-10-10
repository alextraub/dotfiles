-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
  for _, cmd in ipairs(require("hypr-vars").autostarts or {}) do
    hl.exec_cmd(cmd)
  end
end)

require("modules.keybinds")
require("modules.rules")
require("modules.launcher")
require("modules.roles")

hl.config({
  general = {
    resize_on_border = true,
  },
})

hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })
hl.monitor({
  output   = "desc:Microstep MAG274QRF-QD CA8A291700643",
  mode     = "2560x1440@164.84Hz",
  position = "0x0",
  scale    = 1,
})
hl.monitor({
  output   = "desc:ASUSTek COMPUTER INC PG27AQDM S3LMRS014609",
  mode     = "2560x1440@239.97Hz",
  position = "2560x0",
  scale    = 1,
})
hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto",
  scale    = "auto",
})

hl.env("__GL_GSYNC_ALLOWED", "1")
hl.env("__GL_VRR_ALLOWED", "1")

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name  = "fix-xwayland-drags",
  match = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },

  no_focus = true,
})