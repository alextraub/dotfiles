-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function ()
  hl.exec_cmd("hypridle")
  -- Vicinae aborts at startup without a Secret Service on D-Bus, and KWallet's isn't
  -- D-Bus-activatable outside Plasma, so start it and wait for it to claim the name first.
  -- pam_kwallet_init starts kwalletd6 unlocked with the login password SDDM's PAM caught
  hl.exec_cmd("/usr/lib/pam_kwallet_init & until busctl --user status org.freedesktop.secrets >/dev/null 2>&1; do sleep 0.2; done; vicinae server")
  hl.exec_cmd("pipeweaver-daemon --background")
  hl.exec_cmd("awww-daemon & qs & swaync")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

