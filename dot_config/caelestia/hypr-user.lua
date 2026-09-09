-- Startup
hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm app -s b -t service -a ghostty-daemon -- ghostty --initial-window=false --quit-after-last-window-closed=false")
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
	match = { class = "io.missioncenter.MissionCenter" },
	workspace = "special:sysmon",
})
