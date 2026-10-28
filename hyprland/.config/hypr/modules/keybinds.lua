---------------------
---- MY PROGRAMS ----
---------------------
local terminal = "ghostty"
local fileManager = "nemo"
local browser = "if command -v zen >/dev/null 2>&1; then zen; else flatpak run app.zen_browser.zen; fi"
-- Let Spotify detect Wayland instead of rendering through blurry XWayland.
local music = "if command -v spotify >/dev/null 2>&1; then env -u DISPLAY spotify; elif [ -x /snap/bin/spotify ]; then env -u DISPLAY /snap/bin/spotify; else notify-send 'Spotify not found' 'Install Spotify or check its launcher.'; fi"
-- local launcher = "rofi -show drun -show-icons"
local launcher = "vicinae toggle"
local runner = "rofi -show run"
local screenshot = 'hyprshot -m'

---------------------
---- KEYBINDINGS ----
---------------------
local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local secondMod = "SUPER + SHIFT" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind("Print", hl.dsp.exec_cmd(screenshot .. "window"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(screenshot .. "region"))
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("quickshell --no-duplicate --path /home/meli/.config/quickshell/lockscreen"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(music))
hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind(mainMod .. " + ALT + 1", hl.dsp.exec_cmd("if tuned-adm profile powersave; then notify-send -u low '   Power mode' 'Power saver enabled'; else notify-send -u critical ' Power mode' 'Failed to switch to power saver'; fi"))
hl.bind(mainMod .. " + ALT + 2", hl.dsp.exec_cmd("if tuned-adm profile balanced; then notify-send -u normal '   Power mode' 'Balanced mode enabled'; else notify-send -u critical ' Power mode' 'Failed to switch to balanced mode'; fi"))
hl.bind(mainMod .. " + ALT + 3", hl.dsp.exec_cmd("if tuned-adm profile throughput-performance; then notify-send -u normal '  Power mode' 'Performance mode enabled'; else notify-send -u critical ' Power mode' 'Failed to switch to performance mode'; fi"))
hl.bind(mainMod .. " + X", hl.dsp.window.close())
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(launcher))
hl.bind(secondMod .. " + Space", hl.dsp.exec_cmd(runner))

hl.bind(
	secondMod .. " + Q",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- Move focus with mainMod + vim keybinds
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move windows with secondMod + vim keybinds
hl.bind(secondMod .. " + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(secondMod .. " + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(secondMod .. " + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(secondMod .. " + j", hl.dsp.window.move({ direction = "down" }))

hl.bind(secondMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(secondMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- Cycle workspaces with mainMod + Tab / secondMod + Tab.
hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(secondMod .. " + TAB", hl.dsp.focus({ workspace = "e-1" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
