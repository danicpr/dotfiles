-- Startup
hl.on("hyprland.start", function()
	hl.exec_cmd("shelly-notifications")
	hl.exec_cmd("ghostty --initial-window=false")
end)

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "altgr-intl",
	},
})

hl.window_rule({
	match = { class = "io.missioncenter.MissionCenter" },
	workspace = "special:sysmon",
})
