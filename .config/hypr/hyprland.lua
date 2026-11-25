-- hyprland.lua (converted from hyprland.conf, targeting Hyprland 0.56.x)

------------------
--- VARIABLES  ---
------------------
local mainMod     = "SUPER"
local terminal    = "ghostty"
local fileManager = "nemo"
local menu        = "fuzzel"

------------------
--- MONITORS   ---
------------------
-- don't try to get HDR working on this monitor. i tried it, it sucks, there's no differences
hl.monitor({ output = "DP-1",     mode = "2560x1440@143.97", position = "0x0",     scale = "auto" })
hl.monitor({ output = "DP-2",     mode = "1920x1080@60",  position = "2560x360", scale = "auto", mirror = "DP-3" }) -- UNVERIFIED key: "mirror"
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60",     position = "-1920x0", scale = "1" })

hl.workspace_rule({ workspace = "1", monitor = "DP-1" })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "3", monitor = "DP-3" })
hl.workspace_rule({ workspace = "3", monitor = "DP-2" })

------------------
--- ENV        ---
------------------
hl.env("WLR_XWAYLAND_OUTPUTS", "DP-1")
hl.env("WLR_XWAYLAND_MASTER_OUTPUT", "DP-1")

-- xdg-desktop-portal-hyprland needs this; as of 6/11/26 it's no longer set, so the portal never runs.
-- third arg = also export to dbus
hl.env("XDG_SESSION_DESKTOP", "Hyprland", true)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("HYPRSHOT_DIR", "Pictures/hyprshot/")
-- fix Dolphin's file associations dropping on occasional upgrades
hl.env("XDG_MENU_PREFIX", "arch-")

------------------
--- AUTOSTART  ---
------------------
-- order preserved from the old exec-once lines
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start graphical-session.target")
    hl.exec_cmd("systemctl --user import-environment XDG_SESSION_DESKTOP")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("~/.config/custom/scripts/set-primary-dp1.sh")
    hl.exec_cmd("waybar")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("kbuildsycoca6")
    -- manually load the hyprland plugins that are already enabled
    hl.exec_cmd("hyprpm reload")
end)

-- old `exec =` (runs on every reload, not just startup)
hl.exec_cmd([[gsettings set org.gnome.desktop.interface gtk-theme "Breeze-Dark"]])
hl.exec_cmd([[gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"]])

------------------
--- CONFIG     ---
------------------
hl.config({
    debug = {
        disable_logs = false,
    },

    general = {
        gaps_in  = 2,
        gaps_out = 4,
        border_size = 1,
        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = false,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        key_press_enables_dpms = true,
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        font_family = "Iosevka Custom",
    },

    input = {
        kb_layout = "us",
        kb_options = "numpad:mac",
        follow_mouse = 1,
        sensitivity = -0.75,
        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- hyprbars: needs the plugin loaded first, so apply on reload.
-- UNVERIFIED: if bar_height doesn't apply, run `hyprctl reload` once after login.
hl.on("config.reloaded", function()
    hl.config({
        plugin = {
            hyprbars = {
                bar_height = 20,
                bar_precedence_over_border = true,
            },
        },
    })
end)

------------------
--- ANIMATIONS ---
------------------
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

for _, leaf in ipairs({
    "global", "border", "windows", "windowsIn", "windowsOut",
    "fadeIn", "fadeOut", "fade",
    "layers", "layersIn", "layersOut", "fadeLayersIn", "fadeLayersOut",
    "workspaces", "workspacesIn", "workspacesOut",
}) do
    hl.animation({ leaf = leaf, enabled = true, speed = 1, bezier = "linear" })
end

------------------
--- KEYBINDS   ---
------------------
hl.bind(mainMod .. " + Return",    hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + W",         hl.dsp.window.close())
hl.bind(mainMod .. " + BackSpace", hl.dsp.window.kill())
hl.bind(mainMod .. " + M",         hl.dsp.exit())
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + T",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R",         hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P",         hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + Escape",    hl.dsp.exec_cmd("/home/ranthos/zoomer"))

-- NOTE: SUPER+L is bound twice (screen off AND focus right), same as your old config. Both fire.
hl.bind(mainMod .. " + L",
    hl.dsp.exec_cmd([[sleep 1 && hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })']]))

hl.bind("CTRL + " .. mainMod .. " + End", hl.dsp.exec_cmd("/home/ranthos/.config/custom/scripts/powermenu.sh"))

hl.bind("ALT + Tab",       hl.dsp.exec_cmd("/home/ranthos/.config/custom/scripts/alt_tab/hypr_alt_tab.sh"))
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("/home/ranthos/.config/custom/scripts/alt_tab/hypr_alt_tab_hold.sh"))

-- focus: arrows
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- focus: hjkl
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- screenshots
hl.bind("Print", hl.dsp.exec_cmd("hyprshot --freeze --mode region"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot --freeze --raw --mode region | swappy -f -"))

-- workspaces 1-10
for i = 1, 10 do
    local key = i % 10 -- 10 -> key 0
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- mouse move/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- volume / brightness (old bindel = locked + repeating)
local lr = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), lr)
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), lr)
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), lr)
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), lr)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s 10%+"), lr)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), lr)

-- media (old bindl = locked)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

------------------
--- WINDOW RULES -
------------------
-- ignore maximize requests from apps
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

hl.window_rule({ match = { class = "^(steam_app.*)$" }, border_size = 0, rounding = 0 })
hl.window_rule({ match = { fullscreen = true }, border_size = 0 })

-- sneakily disable alpha on fullscreen windows
-- i love fullscreen terminals making it seem like i'm just on a terminal
hl.window_rule({ match = { fullscreen = true }, force_rgbx = true })

-- fix some dragging issues with XWayland (old rule name: fix-drag-wayland)
hl.window_rule({
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

hl.window_rule({ match = { class = "^(kitty)$", xwayland = true }, tile = true })

hl.window_rule({ match = { class = "org.gnome.Calculator" }, float = true, persistent_size = true })
hl.window_rule({ match = { class = "steam_app_3560" },       float = true, persistent_size = true })

-- fix godot main window floating
hl.window_rule({ match = { class = "^(Godot)$", initial_title = "^(Godot)$" }, tile = true })

-- (dropped: ghostty "no-titlebar" rule; it had no effect, its only line was commented out)
