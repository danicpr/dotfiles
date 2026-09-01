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
hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme MacTahoe-dark")
