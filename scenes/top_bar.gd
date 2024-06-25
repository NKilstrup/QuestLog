extends MarginContainer

const SETTINGS_WINDOW: PackedScene = preload("res://scenes/settings_window.tscn")
const NEW_TAB_WINDOW: PackedScene = preload("res://scenes/new_tab_window.tscn")
const PROJECTS_WINDOW: PackedScene = preload("res://scenes/projects_window.tscn")

@onready var top_bar_panel_background: Panel = %TopBarPanelBackground
@onready var top_bar_panel_color: Panel = %TopBarPanelColor
@onready var calendar_label: Label = %CalendarLabel

@onready var calendar_left_button: GenericButton = %CalendarLeftButton
@onready var calendar_right_button: GenericButton = %CalendarRightButton

@onready var projects_button: MarginContainer = %ProjectsButton
@onready var new_tab_button: MarginContainer = %NewTabButton
@onready var settings_button: MarginContainer = %SettingsButton

var color: Color
var inactive_color: Color
var highlight_color: Color

func _ready() -> void:
	Global.recolor_top_bar.connect(setup_color)
	Global.theme_changed.connect(check_theme_coloring)
	Global.theme_font_color_changed.connect(setup_font)

func setup_color(_color: Color = Global.theme_accent_color) -> void:
	color = _color
	
	inactive_color = color
	inactive_color.s -= Global.inactive_color_saturation
	inactive_color.v -= Global.inactive_color_value
	
	highlight_color = color
	highlight_color.s = Global.highlight_color_saturation
	highlight_color.v = Global.highlight_color_value
	
	top_bar_panel_background.modulate = color
	top_bar_panel_color.modulate = color
	
	calendar_left_button.setup_color(color)
	calendar_right_button.setup_color(color)
	projects_button.setup_color(color)
	new_tab_button.setup_color(color)
	settings_button.setup_color(color)
	
	check_theme_coloring(Global.active_theme)

func check_theme_coloring(_theme: String) -> void:
	if _theme == "atomic":
		calendar_label.modulate = color
	else:
		calendar_label.modulate = Color.WHITE

func setup_font():
	if Global.label_settings.has("top_bar_label_settings"):
		calendar_label.label_settings = Global.label_settings["top_bar_label_settings"]

func _on_settings_button_pressed() -> void:
	var settings_window = SETTINGS_WINDOW.instantiate()
	Global.task_description_layer.add_child(settings_window)
	Global.task_description_layer.show()
	settings_window.setup_window_color(color)

func _on_new_tab_button_pressed() -> void:
	var new_tab_window = NEW_TAB_WINDOW.instantiate()
	Global.task_description_layer.add_child(new_tab_window)
	Global.task_description_layer.show()
	new_tab_window.set_tab_color(color)
	new_tab_window.setup_font()

func _on_projects_button_button_clicked() -> void:
	var projects_window = PROJECTS_WINDOW.instantiate()
	projects_window.window_color = color
	Global.task_description_layer.add_child(projects_window)
	Global.task_description_layer.show()
