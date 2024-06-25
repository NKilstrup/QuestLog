extends MarginContainer

@onready var minimize_button: GenericButton = %MinimizeButton
@onready var quit_button: GenericButton = %QuitButton
@onready var bar_background: Panel = %BarBackgroundColor

var following: bool = false
var drag_start_position: Vector2

func _ready() -> void:
	Global.recolor_top_bar.connect(setup_color)

func setup_color(color: Color = Global.theme_accent_color) -> void:
	bar_background.modulate = color
	minimize_button.setup_color(color)
	quit_button.setup_color(color)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left click"):
		following = true
		drag_start_position = get_global_mouse_position()
	elif event.is_action_released("left click"):
		following = false

func _process(_delta: float) -> void:
	if following:
		var mouse_position = get_global_mouse_position()
		var window_position = Vector2(DisplayServer.window_get_position())
		DisplayServer.window_set_position(window_position + (mouse_position - drag_start_position))

func _on_minimize_button_button_clicked() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)

func _on_quit_button_button_clicked() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
