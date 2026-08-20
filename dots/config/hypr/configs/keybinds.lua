---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local fileManager = "nemo"
local menu = "hyprlauncher"
local browser = "firefox"

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("kitty -e nvim"))
hl.bind(
	mainMod .. " + I",
	hl.dsp.exec_cmd(
		"kitty -e impala",
		{ tag = "float", pin = true, stay_focused = true, size = { "monitor_w * 0.5", "monitor_h * 0.5" } }
	)
)
hl.bind("SUPER + SHIFT + s", hl.plugin.hyprcapture.open)

hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind("KP_Right", hl.dsp.exec_cmd("python3 /home/miguel/.config/apps/wallchange/wallchange.py next"))
hl.bind("KP_Left", hl.dsp.exec_cmd("python3 /home/miguel/.config/apps/wallchange/wallchange.py prev"))

hl.bind("KP_Begin", hl.dsp.exec_cmd("qs -p /home/miguel/.config/quickshell/apps/Wallpicker.qml"))

hl.bind("KP_Enter", hl.dsp.global("quickshell:togglePanel"))
-----------------------
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

local win = hl.dsp.window
local resize_opts = {
	left = { x = -20, y = 0, relative = true },
	up = { x = 0, y = 20, relative = true },
	down = { x = 0, y = -20, relative = true },
	right = { x = 20, y = 0, relative = true },
}

for key, opts in pairs(resize_opts) do
	hl.bind("SHIFT + " .. key, win.resize(opts), { repeating = true })
end

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

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
