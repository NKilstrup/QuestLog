extends MarginContainer

const BUTTON_FADE_TIME: float = 0.1

@onready var move_left_button: GenericButton = %MoveLeftButton
@onready var move_right_button: GenericButton = %MoveRightButton
@onready var edit_button: GenericButton = %EditButton
@onready var delete_button: GenericButton = %DeleteButton

var buttons_hidden: bool = false
var tab_color: Color
var inactive_color: Color
var highlight_color: Color

func _ready() -> void:
	Global.theme_accent_color_changed.connect(set_buttons_color)
	disable_buttons()
	
	await get_tree().create_timer(0.1).timeout
	set_buttons_color()

func disable_buttons() -> void:
	if buttons_hidden:
		return
	
	buttons_hidden = true
	tween_animate(edit_button, "modulate", Color(1, 1, 1, 0), BUTTON_FADE_TIME)
	tween_animate(delete_button, "modulate", Color(1, 1, 1, 0), BUTTON_FADE_TIME)
	tween_animate(move_left_button, "modulate", Color(1, 1, 1, 0), BUTTON_FADE_TIME)
	tween_animate(move_right_button, "modulate", Color(1, 1, 1, 0), BUTTON_FADE_TIME)
	
	edit_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	delete_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	move_left_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	move_right_button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func enable_buttons() -> void:
	if not buttons_hidden:
		return
	
	buttons_hidden = false
	tween_animate(edit_button, "modulate", Color(1, 1, 1, 1), BUTTON_FADE_TIME)
	tween_animate(delete_button, "modulate", Color(1, 1, 1, 1), BUTTON_FADE_TIME)
	tween_animate(move_left_button, "modulate", Color(1, 1, 1, 1), BUTTON_FADE_TIME)
	tween_animate(move_right_button, "modulate", Color(1, 1, 1, 1), BUTTON_FADE_TIME)
	
	edit_button.mouse_filter = Control.MOUSE_FILTER_PASS
	delete_button.mouse_filter = Control.MOUSE_FILTER_PASS
	move_left_button.mouse_filter = Control.MOUSE_FILTER_PASS
	move_right_button.mouse_filter = Control.MOUSE_FILTER_PASS

func set_buttons_color() -> void:
	inactive_color = tab_color
	inactive_color.s -= 0.12
	inactive_color.v -= 0.4
	
	highlight_color = tab_color
	highlight_color.s = Global.highlight_color_saturation
	highlight_color.v = Global.highlight_color_value
	
	move_left_button.setup_color(tab_color)
	move_right_button.setup_color(tab_color)
	edit_button.setup_color(tab_color)
	delete_button.setup_color(tab_color)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and buttons_hidden:
		enable_buttons()

func _on_mouse_exited() -> void:
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()) and not buttons_hidden:
		disable_buttons()

func tween_animate(object: Node, property: String, to_value: Variant, duration: float) -> void:
	var tween = create_tween()
	tween.tween_property(object, property, to_value, duration).set_trans(Tween.TRANS_SINE)
	await tween.finished
	tween.kill()

