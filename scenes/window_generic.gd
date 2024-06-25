extends MarginContainer
class_name GenericWindow

@onready var background: Panel = $Background
@onready var background_color: Panel = $Background/BackgroundColor
@onready var decoration: Control = %Decoration
@onready var top_decoration: Control = %TopDecoration

@export var background_style: String = "" :
	set(theme_type):
		await ready
		background.theme_type_variation = theme_type

@export var background_color_style: String = "TabBackgroundColor" :
	set(theme_type):
		await ready
		background_color.theme_type_variation = theme_type

@export var decorations: bool = true :
	set(visibility):
		await ready
		decoration.visible = visibility
		top_decoration.visible = visibility

var color: Color
var inactive_color: Color
var highlight_color: Color

func _ready() -> void:
	setup_color(Global.theme_accent_color)
	open_window()
	blink()

func setup_color(_color: Color) -> void:
	color = _color
	background_color.modulate = _color
	
	inactive_color = _color
	inactive_color.s -= Global.inactive_color_saturation
	inactive_color.v -= Global.inactive_color_value
	
	highlight_color = _color
	highlight_color.s = Global.highlight_color_saturation
	highlight_color.v = Global.highlight_color_value

func open_window() -> void:
	scale = Vector2(1, 0)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1)

func blink() -> void:
	background_color.modulate = highlight_color
	var tween := create_tween()
	tween.tween_property(background_color, "modulate", color, 0.4)
	await tween.finished
	tween.kill()
