-- QML overlay path for custom Caelestia.Blobs Liquid Glass shader
hl.env("QML2_IMPORT_PATH", os.getenv("HOME") .. "/.local/share/caelestia-qml")

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
	decoration = {
		blur = {
			noise = 0.01,
			contrast = 1.06,
			brightness = 1.02,
			vibrancy = 0.16,
			vibrancy_darkness = 0.15,
		},
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

if hl.plugin then
	pcall(hl.plugin.load, os.getenv("HOME") .. "/.local/share/hypr/plugins/hyprglass.so")
end

if hl.plugin and hl.plugin.hyprglass then
	local hg = hl.plugin.hyprglass

	hg.preset("caelestia_glass", {
		inherits = "pomme",
		blur_strength = 0.80,
		blur_iterations = 2,
		refraction_strength = 0.68,
		chromatic_aberration = 0.50,
		fresnel_strength = 0.55,
		specular_strength = 0.72,
		bevel_strength = 0.42,
		bevel_size = 4.0,
		edge_height = 18.0,
		edge_thickness_px = 12.0,
		fresnel_reflection = 0.24,
		lens_distortion = 0.22,
		glass_opacity = 0.92,
		dark = {
			brightness = 0.92,
			contrast = 1.05,
			saturation = 1.05,
			vibrancy = 0.18,
			adaptive_dim = 0.20,
		},
	})

	hg.config({
		default_theme = "dark",
		default_preset = "caelestia_glass",
		layers = {
			enabled = true,
			manage_blur = true,
		},
	})

	hg.layer("caelestia-drawers", {
		preset = "caelestia_glass",
		mask_mode = "contour",
		mask_threshold = 0.20,
		mask_feather = 0.12,
		live_resample = true,
	})
else
	hl.layer_rule({
		match = { namespace = "caelestia-drawers" },
		blur = true,
		ignore_alpha = 0.20,
	})
end

-- Keybinds
hl.bind("CTRL + SHIFT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
