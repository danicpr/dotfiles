-- Startup
hl.on("hyprland.start", function()
	hl.exec_cmd(
		"uwsm app -s b -t service -a ghostty-daemon -- ghostty --initial-window=false --quit-after-last-window-closed=false"
	)
end)

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "altgr-intl",
	},
})

-- hl.window_rule({
-- 	match = { class = "com.mitchellh.ghostty" },
-- 	no_blur = true,
-- })

hl.window_rule({
	match = { class = "zen" },
	opaque = true,
	no_blur = true,
})

hl.window_rule({
	match = { class = "dsh-pwa" },
	opaque = true,
})

hl.window_rule({
	match = { class = "com.shellyorg.shelly" },
	float = true,
})

hl.window_rule({
	match = { class = "[tT]hunar" },
	float = true,
	-- size = "(monitor_w*0.65) (monitor_h*0.75)",
	center = true,
})

-- Keybinds
hl.bind("CTRL + SHIFT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
