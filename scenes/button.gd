extends MarginContainer
class_name GenericButton

signal button_clicked

@onready var button: Button = $Button
@onready var button_background: Panel = $ButtonBackground

@export var button_themetype: String = "ArrowButton" :
	set(theme_type):
		await ready
		button.theme_type_variation = theme_type
@export var background_themetype: String = "SmallButtonBackground" :
	set(theme_type):
		await ready
		button_background.theme_type_variation = theme_type

@export var play_sound: bool = true

var button_color: Color
var button_inactive_color: Color
var button_highlight_color: Color

func _ready() -> void:
	setup_color(Global.theme_accent_color)

func setup_color(color: Color) -> void:
	button_color = color
	
	button_inactive_color = color
	button_inactive_color.s -= Global.inactive_color_saturation
	button_inactive_color.v -= Global.inactive_color_value
	
	button_highlight_color = color
	button_highlight_color.s = Global.highlight_color_saturation
	button_highlight_color.v = Global.highlight_color_value
	
	button.modulate = button_highlight_color
	var tween = create_tween()
	tween.tween_property(button, "modulate", button_inactive_color, 0.2)
	
	check_theme_coloring(Global.active_theme)

func check_theme_coloring(_theme: String) -> void:
	pass

func _on_button_pressed() -> void:
	if play_sound:
		Global.play_audio(Global.SOUND_CLICK)
	button_clicked.emit()
	button.modulate = button_highlight_color
	var tween = create_tween()
	tween.tween_property(button, "modulate", button_inactive_color, 0.2)

func _on_button_mouse_entered() -> void:
	button.modulate = button_color

func _on_button_mouse_exited() -> void:
	button.modulate = button_inactive_color
