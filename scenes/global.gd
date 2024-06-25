extends Node

signal data_loaded
signal theme_changed(_theme: String)
signal theme_accent_color_changed
signal theme_font_color_changed
signal recolor_top_bar
signal recolor_tabs
signal recolor_tasks
signal change_resolution(to_resolution: String)
signal audio_settings_changed(enabled: bool, volume: float)
signal new_task_tab_requested(title: String, color: Color)
signal current_time(month: String, weekday: String, day: String, year: String)

signal create_project(project: String)
signal remove_project(project: String)
signal switch_project(project: String)
signal project_switched(project: String)
signal rename_project(new_title: String, old_title: String)
signal project_renamed(new_title: String, old_title: String)

var projects: Array
var current_project: String
var themes: Dictionary
var active_theme: String
var active_theme_files: Theme
var theme_accent_color: Color = Color(0.769, 0.486, 0.722)
var theme_font_color: Color = Color.WHITE
var theme_font: Font 
var label_settings: Dictionary
var sound_effects: bool = true
var sound_effects_volume: float = 100
var SOUND_CLICK: AudioStream
var DROP_SOUND: AudioStream

var inactive_color_saturation: float = 0.15
var inactive_color_value: float = 0.2
var highlight_color_saturation: float = 0.5
var highlight_color_value: float = 1.8

var task_description_layer: Control
var is_dragging: bool = false
var copied_color: Color

var current_month: String
var current_weekday: String
var current_day: String
var current_year: String

var resolution_options: Dictionary = {
	"1280x720": Vector2i(1280, 720),
	"1408x792": Vector2i(1408, 792),
	"1536x864": Vector2i(1536, 864),
	"1664x936": Vector2i(1664, 936),
	"1920x1080": Vector2i(1920, 1080),
	"2048x1152": Vector2i(2048, 1152),
	"2176x1224": Vector2i(2176, 1224),
	"2304x1296": Vector2i(2304, 1296),
	"2432x1368": Vector2i(2432, 1368),
	"2560x1440": Vector2i(2560, 1440)
}

func _ready() -> void:
	current_time.connect(setup_global_time)
	
	await get_tree().create_timer(0.1).timeout
	Global.play_audio()

func setup_global_time(month: String, weekday: String, day: String, year: String) -> void:
	current_month = month
	current_weekday = weekday
	current_day = day
	current_year = year

func play_audio(audio: AudioStream = SOUND_CLICK) -> void:
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = audio
	audio_player.pitch_scale = randf_range(0.8, 1.15)
	get_tree().root.add_child(audio_player)
	audio_player.play()
	
	await audio_player.finished
	audio_player.queue_free()
