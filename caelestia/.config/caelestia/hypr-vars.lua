-- Overrides for ~/.config/hypr/variables.lua. Only list values that differ from the defaults there.
local scheme = require("scheme.current") -- Written by caelestia-cli on scheme changes

return {
    ------------------
    ---- HYPRLAND ----
    ------------------

    -- Apps
    terminal                   = "ghostty",
    browser                    = "zen-browser",

    -- Shell
    shellCmd                   = "qs",
    shellKillCmd               = "qs kill",

    -- Window styling
    activeWindowBorderColour   = { colors = { "rgb(" .. scheme.primary .. ")", "rgb(" .. scheme.secondary .. ")" }, angle = 45 },
    inactiveWindowBorderColour = "rgba(" .. scheme.surfaceContainerHighest .. "ab)",
    shadowColour               = "rgba(" .. scheme.background .. "ed)",

    -- Misc
    cursorTheme                = "Sweet-cursors", -- Folder name from the AUR sweet-cursors-git package
    polkitAgentCmd             = "systemctl --user reset-failed hyprpolkitagent; systemctl --user start hyprpolkitagent", -- reset-failed: a Hyprland restart can leave it start-limit-hit

    -- Commands run once at login, in order (see hypr-user.lua)
    autostarts                 = {
        "hypridle",
        -- Vicinae aborts at startup without a Secret Service on D-Bus, so wait for gnome-keyring
        -- (started in hyprland/execs.lua, unlocked by SDDM's pam_gnome_keyring) to claim the name first
        "until busctl --user status org.freedesktop.secrets >/dev/null 2>&1; do sleep 0.2; done; vicinae server",
        "pipeweaver-daemon --background",
        "awww-daemon",
        "swaync",
    },

    ------------------
    ---- KEYBINDS ----
    ------------------

    -- Workspace digits. Empty turns off upstream's mod + 0-9 binds: modules/keybinds.lua binds
    -- SUPER (+ SHIFT) + 0-9 per monitor role instead, so they follow a SUPER + SHIFT + Tab swap
    kbGoToWs                   = "",
    kbMoveWinToWs              = "",
    kbGoToWsGroup              = "",
    kbMoveWinToWsGroup         = "",

    -- Window Actions. SUPER + Minus / Equal are left out, they zoom (modules/keybinds.lua)
    kbWindowDecreaseWidth      = { "SUPER + ALT + Left" },
    kbWindowIncreaseWidth      = { "SUPER + ALT + Right" },

    -- Apps
    kbTerminal                 = "SUPER + Return",
}
