extends Resource
class_name SettingsData

const DATA_PATH := "user://settings.tres"

@export var current_resolution: String = "1920x1080"
@export var current_project: String = "default"
@export var theme_accent_color: Color = Color(0.769, 0.486, 0.722)
@export var sound_effects: bool = true
@export var sound_effects_volume: float = 100

func write_data() -> void:
	ResourceSaver.save(self, DATA_PATH)

static func load_data() -> SettingsData:
	var res:SettingsData
	if ResourceLoader.exists(DATA_PATH):
		return load(DATA_PATH)
	else:
		res = SettingsData.new()
	return res
