-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
--
-- Rules that put a workspace or app on a specific monitor belong in modules/roles.lua
-- instead, so they follow the main/side swap on SUPER + X

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this.
  name  = "suppress-maximize-events",
  match = { class = ".*" },

  suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(true)

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

hl.window_rule({
  -- No inactive border on Vesktop. Transparent rather than border_size = 0 so the
  -- window doesn't shift when focus changes; the active border stays as is, since
  -- the rule only matches while unfocused. Two colors set active and inactive;
  -- a single color would only set the active one
  name         = "vesktop-no-inactive-border",
  match        = { class = "^vesktop$", focus = false },
  border_color = "rgba(00000000) rgba(00000000)",
})

hl.window_rule({
  -- No shadow or blur on Vesktop, focused or not: its see-through theme shows the
  -- desktop behind it unblurred
  name      = "vesktop-no-shadow-blur",
  match     = { class = "^vesktop$" },
  no_shadow = true,
  no_blur   = true,
})

