extends Resource
class_name Themes

const DATA_PATH := "user://themes.tres"

@export var active_theme: String = "gothic"

@export var themes: Dictionary = {
	"gothic": {
			"theme_texture": "res://assets/textures/theme_ui_gothic.png",
			"theme_font": "res://assets/fonts/font_gothic.otf",
			"theme_font_color": Color(1, 0.929, 0.769),
			"theme_click_sound": "res://assets/audio/click_gothic.mp3",
			"theme_drop_sound": "res://assets/audio/drop_gothic.mp3"
	},
	"hagaki": {
			"theme_texture": "res://assets/textures/theme_ui_hagaki.png",
			"theme_font": "res://assets/fonts/font_hagaki.ttf",
			"theme_font_color": Color(1, 0.929, 0.769),
			"theme_click_sound": "res://assets/audio/click_hagaki.mp3",
			"theme_drop_sound": "res://assets/audio/drop_hagaki.mp3"
	},
	"atomic": {
			"theme_texture": "res://assets/textures/theme_ui_atomic.png",
			"theme_font": "res://assets/fonts/font_atomic.ttf",
			"theme_font_color": Color.WHITE,
			"theme_click_sound": "res://assets/audio/click_atomic.mp3",
			"theme_drop_sound": "res://assets/audio/drop_atomic.mp3"
	}
}

func write_data() -> void:
	ResourceSaver.save(self, DATA_PATH)

static func load_data() -> Themes:
	var res:Themes
	if ResourceLoader.exists(DATA_PATH):
		return load(DATA_PATH)
	else:
		res = Themes.new()
	return res

func get_theme(theme: String) -> Dictionary:
	match theme:
		"gothic":
			return themes["gothic"]
		"hagaki":
			return themes["hagaki"]
		"atomic":
			return themes["atomic"]
		_:
			return {}

func add_theme(name: String, texture: String, font: String, font_color: Color, click: String, drop: String) -> void:
	themes.name = {
		"theme_texture": texture,
		"theme_font": font,
		"theme_font_color": font_color,
		"theme_click_sound": click,
		"theme_drop_sound": drop
	}

func remove_theme(name: String) -> void:
	if themes.has(name):
		themes.erase(name)
	else:
		print("no such theme name exists")
		return
