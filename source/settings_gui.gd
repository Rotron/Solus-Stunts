# Copyright © 2017 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

# The preset to use when starting the project
# 0: Low
# 1: Medium
# 2: High
# 3: Ultra
const default_preset = 2

# The available display resolutions
const display_resolutions = [
	Vector2(1280, 720),
	Vector2(1366, 768),
	Vector2(1600, 900),
	Vector2(1920, 1080),
	Vector2(2560, 1440),
	Vector2(3200, 1800),
	Vector2(3840, 2160),
]

const mix_target_presets = [
	"Stereo", "Surround", "Center"
]

# The description texts for each preset
const preset_descriptions = [
	"For low-end PCs with integrated graphics, as well as mobile devices.",
	"For mid-range PCs with slower dedicated graphics.",
	"For recent PCs with mid-range dedicated graphics, or older PCs with high-end graphics.",
	"For recent PCs with high-end dedicated graphics.",
]

# The presets' settings
#
# Each key contains an array. Index 0 is the actual setting, index 1 is the
# value to display in the preset summary GUI (which may be empty, in case it is
# not displayed).
#
# The following categories are not actually part of the Project Settings, but
# are applied to the relevant nodes instead:
#   - "environment"

const presets = [
	# Low
	{
		"environment/glow_enabled": [false, "Disabled"],
		"environment/ss_reflections_enabled": [false, "Disabled"],
		"environment/ssao_enabled": [false, "Disabled"],
		"environment/ssao_blur": [Environment.SSAO_BLUR_1x1, ""],
		"environment/ssao_quality": [Environment.SSAO_QUALITY_LOW, ""],
		"rendering/quality/anisotropic_filter_level": [2, "2×"],
		"rendering/quality/filters/msaa": [Viewport.MSAA_2X, "2×"],
		"rendering/quality/voxel_cone_tracing/high_quality": [false, "Low-quality"],
	},

	# Medium
	{
		"environment/glow_enabled": [false, "Disabled"],
		"environment/ss_reflections_enabled": [false, "Disabled"],
		"environment/ssao_enabled": [false, "Disabled"],
		"environment/ssao_blur": [Environment.SSAO_BLUR_1x1, ""],
		"environment/ssao_quality": [Environment.SSAO_QUALITY_LOW, ""],
		"rendering/quality/anisotropic_filter_level": [8, "8×"],
		"rendering/quality/filters/msaa": [Viewport.MSAA_2X, "2×"],
		"rendering/quality/voxel_cone_tracing/high_quality": [false, "Low-quality"],
	},

	# High
	{
		"environment/glow_enabled": [true, "Enabled"],
		"environment/ss_reflections_enabled": [false, "Disabled"],
		"environment/ssao_enabled": [true, "Medium-quality"],
		"environment/ssao_blur": [Environment.SSAO_BLUR_1x1, ""],
		"environment/ssao_quality": [Environment.SSAO_QUALITY_LOW, ""],
		"rendering/quality/anisotropic_filter_level": [16, "16×"],
		"rendering/quality/filters/msaa": [Viewport.MSAA_4X, "4×"],
		"rendering/quality/voxel_cone_tracing/high_quality": [false, "Low-quality"],
	},

	# Ultra
	{
		"environment/glow_enabled": [true, "Enabled"],
		"environment/ss_reflections_enabled": [true, "Enabled"],
		"environment/ssao_enabled": [true, "High-quality"],
		"environment/ssao_blur": [Environment.SSAO_BLUR_2x2, ""],
		"environment/ssao_quality": [Environment.SSAO_QUALITY_MEDIUM, ""],
		"rendering/quality/anisotropic_filter_level": [16, "16×"],
		"rendering/quality/filters/msaa": [Viewport.MSAA_8X, "8×"],
		"rendering/quality/voxel_cone_tracing/high_quality": [true, "High-quality"],
	},
]

# The root of the Lobby
onready var root = $"/root/lobby3D"

# The environment resource used for settings adjustments
onready var environment = root.get_environment()

# Nodes used in the menu
onready var GraphicsBlurb = $"Panel/GraphicsBlurb"
onready var GraphicsInfo = $"Panel/GraphicsInfo"
onready var ResolutionDropdown = $"Panel/DisplayResolution/display_resolution"
onready var AudioDropdown = $"Panel/Mix target/target"

func _ready():
	# Initialize the project on the default preset
	$"Panel/GraphicsQuality/graphics_preset".select(default_preset)
	_on_graphics_preset_item_selected(default_preset)
	# Cache screen size into a variable
	var screen_size = OS.get_screen_size()

	# Add resolutions to the display resolution dropdown
	for resolution in display_resolutions:
		if resolution.x < screen_size.x and resolution.y < screen_size.y:
			ResolutionDropdown.add_item(str(resolution.x) + "×" + str(resolution.y))
	
	for target in mix_target_presets:
		AudioDropdown.add_item(target)

	# Add a "Fullscreen" item at the end
	ResolutionDropdown.add_item("Fullscreen")

	# Select the "Fullscreen" item, which is always at the end
	ResolutionDropdown.select(ResolutionDropdown.get_item_count() - 1)



# Returns a string containing BBCode text of the preset description
func construct_bbcode(preset):
	return """[table=2]
[cell][b]Anti-aliasing[/b][/cell] [cell]""" + str(presets[preset]["rendering/quality/filters/msaa"][1]) + """[/cell]
[cell][b]Anisotropic filtering[/b][/cell] [cell]""" + str(presets[preset]["rendering/quality/anisotropic_filter_level"][1]) + """[/cell]
[cell][b]Global illumination[/b][/cell] [cell]""" + str(presets[preset]["rendering/quality/voxel_cone_tracing/high_quality"][1]) + """[/cell]
[cell][b]Ambient occlusion[/b][/cell] [cell]""" + str(presets[preset]["environment/ssao_enabled"][1]) + """[/cell]
[cell][b]Bloom[/b][/cell] [cell]""" + str(presets[preset]["environment/glow_enabled"][1]) + """[/cell]
[cell][b]Screen-space reflections[/b][/cell] [cell]""" + str(presets[preset]["environment/ss_reflections_enabled"][1]) + """[/cell]
[/table]"""



func _on_ConfirmButton_pressed():
	visible = false

func _on_QuitButton_pressed():
	get_tree().quit()


	


func _on_HSlider_value_changed( value ):
	$"AudioStreamPlayer".volume_db = -50 + value/2



func _on_display_resolutionn_item_selected( ID ):
	if ID < ResolutionDropdown.get_item_count() - 1:
		OS.set_window_fullscreen(false)
		OS.set_window_size(display_resolutions[ID])
		# May be maximized automatically if the previous window size was bigger than screen size
		OS.set_window_maximized(false)
	else:
		# The last item of the OptionButton is always "Fullscreen"
		OS.set_window_fullscreen(true)


func _on_graphics_preset_item_selected( ID ):
	# Update preset blurb
	GraphicsBlurb.bbcode_text = preset_descriptions[ID]

	# Update the preset summary table
	GraphicsInfo.bbcode_text = construct_bbcode(ID)
	

	# Apply settings from the preset
	for setting in presets[ID]:
		var value = presets[ID][setting][0]
		ProjectSettings.set_setting(setting, value)
		match setting:
			# Environment settings
			"environment/glow_enabled":
				environment.glow_enabled = value
			"environment/ss_reflections_enabled":
				environment.ss_reflections_enabled = value
			"environment/ssao_enabled":
				environment.ssao_enabled = value
			"environment/ssao_blur":
				environment.ssao_blur = value
			"environment/ssao_quality":
				environment.ssao_quality = value

			# Project settings
			"rendering/quality/filters/msaa":
				get_viewport().msaa = value


func _on_target_item_selected( ID ):
	if ID==0:
		$"AudioStreamPlayer".MIX_TARGET_STEREO
	if ID==1:
		$"AudioStreamPlayer".MIX_TARGET_SURROUND
	if ID==2:
		$"AudioStreamPlayer".MIX_TARGET_CENTER
