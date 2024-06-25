extends MarginContainer
class_name Task

const TASK_PREVIEW: PackedScene = preload("res://scenes/task_preview.tscn")
const TASK_DESCRIPTION: PackedScene = preload("res://scenes/task_description.tscn")
const UPDATE_TASK_WINDOW: PackedScene = preload("res://scenes/new_task_window.tscn")
const EXPAND_AMOUNT: Vector2 = Vector2(0, 128)

@onready var task_label: Label = %TaskLabel
@onready var task_panel: Panel = %TaskPanelColor
@onready var edit_button: Button = %EditButton
@onready var delete_button: Button = %DeleteButton
@onready var expand_wait_timer: Timer = %Expand_Wait_Timer

var parent: Node
var mouse_offset: Vector2
var expand_drop_started: bool = false
var expanded_drop_area: bool = false
var tab_expander

var task_title: String = "Task Title"
var task_description: String = ""
var task_color: Color = Global.theme_accent_color
var inactive_color: Color
var highlight_color: Color
var date_created: String
var date_updated: String

var editing: bool = false

func _ready() -> void:
	Global.recolor_tasks.connect(set_task_color)
	Global.theme_changed.connect(check_theme_coloring)
	Global.theme_font_color_changed.connect(setup_font)
	parent = get_parent()
	disable_buttons()
	set_date_created()
	setup_data(task_title, task_description, task_color, date_created, date_created)
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("left click"):
		collapse_tab()
		Global.is_dragging = false
		if visible == false:
			visible = true

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		enable_buttons()
		task_panel.modulate = task_color
	if event is InputEventMouseMotion and Global.is_dragging:
		expand_tab()
	if event.is_action_pressed("right click"):
		show_task_description(task_description)
		task_panel.modulate = highlight_color
		tween_animate(task_panel, "modulate", inactive_color, 0.3)

func _get_drag_data(_at_position: Vector2) -> Variant:
	mouse_offset = position - get_global_mouse_position()
	visible = false
	Global.is_dragging = true
	
	if not editing:
		set_drag_preview(_show_draggable_preview())
	
	return self

func setup_data(title: String, description: String, color: Color, _date_created: String, _date_updated: String) -> void:
	set_task_title(title)
	set_task_description(description, _date_updated)
	set_date_created(_date_created)
	set_task_color(color)
	setup_font()
	disable_buttons()

func set_task_title(title: String) -> void:
	task_title = title
	task_label.text = task_title

func setup_font():
	if Global.label_settings.has("medium_label_settings"):
		task_label.label_settings = Global.label_settings["medium_label_settings"]

func set_task_color(color: Color = Global.theme_accent_color) -> void:
	task_color = color
	inactive_color = task_color
	inactive_color.s -= Global.inactive_color_saturation
	inactive_color.v -= Global.inactive_color_value
	
	highlight_color = task_color
	highlight_color.s = Global.highlight_color_saturation
	highlight_color.v = Global.highlight_color_value
	
	task_panel.modulate = highlight_color
	tween_animate(task_panel, "modulate", inactive_color, 0.3)
	
	check_theme_coloring(Global.active_theme)

func check_theme_coloring(_theme: String) -> void:
	if _theme == "atomic":
		task_label.modulate = task_color
		edit_button.modulate = task_color
		delete_button.modulate = task_color
	else:
		task_label.modulate = Color.WHITE
		edit_button.modulate = Global.theme_font_color
		delete_button.modulate = Global.theme_font_color

func set_task_description(description: String, date_edited: String) -> void:
	task_description = description
	set_date_updated(date_edited)

func set_date_created(_date_created: String = "") -> void:
	if _date_created == "":
		var hours_minutes: String = Time.get_time_string_from_system()
		hours_minutes = hours_minutes.left(hours_minutes.length() - 3)
		date_created = hours_minutes + "/ " + (Global.current_weekday + "/ " + Global.current_day + 
				 "/ " + Global.current_month + "/ " + Global.current_year)
	else:
		date_created = _date_created

func set_date_updated(date: String) -> void:
	date_updated = date

func show_task_description(description: String) -> void: 
	var task_description_window = TASK_DESCRIPTION.instantiate()
	Global.task_description_layer.add_child(task_description_window)
	Global.task_description_layer.show()
	task_description_window.setup_description_window(task_title, description, task_color)
	task_description_window.created_label.text = "Created: " + date_created
	task_description_window.edited_label.text = "Last edited: " + date_updated
	task_description_window.description_updated.connect(set_task_description)

func update_task(title: String, description: String, color: Color):
	editing = false
	set_task_title(title)
	set_task_description(description, date_updated)
	set_task_color(color)

func update_cancelled() -> void:
	editing = false

func expand_tab() -> void:
	if expand_drop_started:
		return
	if expanded_drop_area:
		return
	
	expand_drop_started = true
	
	expand_wait_timer.start()
	await expand_wait_timer.timeout
	
	var task_index = get_index()
	var expander: Control = Control.new()
	parent.add_child(expander)
	parent.move_child(expander, task_index)

	expander.mouse_filter = Control.MOUSE_FILTER_IGNORE
	expander.size = Vector2.ZERO
	expander.custom_minimum_size = Vector2.ZERO
	
	var tween = create_tween()
	tween.tween_property(expander, "custom_minimum_size", Vector2(EXPAND_AMOUNT), 0.2).set_trans(Tween.TRANS_SINE)
	await tween.finished
	
	tab_expander = expander
	expanded_drop_area = true
	expand_drop_started = false

func collapse_tab() -> void:
	if not expanded_drop_area:
		return
	
	var tween = create_tween()
	tween.tween_property(tab_expander, "custom_minimum_size", Vector2.ZERO, 0.05).set_trans(Tween.TRANS_SINE)
	await tween.finished
	if tab_expander != null:
		tab_expander.queue_free()
		expanded_drop_area = false

func disable_buttons() -> void:
	tween_animate(edit_button, "self_modulate", Color(1, 1, 1, 0), 0.1)
	tween_animate(delete_button, "self_modulate", Color(1, 1, 1, 0), 0.1)
	
	edit_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	delete_button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func enable_buttons() -> void:
	tween_animate(edit_button, "self_modulate", Color(1, 1, 1, 1), 0.1)
	tween_animate(delete_button, "self_modulate", Color(1, 1, 1, 1), 0.1)
	edit_button.mouse_filter = Control.MOUSE_FILTER_PASS
	delete_button.mouse_filter = Control.MOUSE_FILTER_PASS

func _show_draggable_preview() -> Control:
	var preview = TASK_PREVIEW.instantiate()
	preview.size = size
	preview.custom_minimum_size.y = size.y
	var offset_container = Control.new()
	offset_container.add_child(preview)
	preview.setup_preview(task_title, task_color)

	preview.position -= get_local_mouse_position()
	return offset_container

func _on_mouse_exited() -> void:
	disable_buttons()
	task_panel.modulate = inactive_color
	
	if not Global.is_dragging:
		collapse_tab()

func tween_animate(object: Node, property: String, to_value: Variant, duration: float) -> void:
	var tween = create_tween()
	tween.tween_property(object, property, to_value, duration).set_trans(Tween.TRANS_SINE)
	await tween.finished
	tween.kill()

func _on_edit_button_pressed() -> void:
	editing = true
	Global.play_audio()
	
	var update_task_window = UPDATE_TASK_WINDOW.instantiate()
	Global.task_description_layer.add_child(update_task_window)
	Global.task_description_layer.show()
	update_task_window.setup_defaults(task_title, task_description, task_color, task_color)
	update_task_window.new_task_label.text = "Update Task"
	update_task_window.task_created.connect(update_task)
	update_task_window.task_not_edited.connect(update_cancelled)

func _on_delete_button_pressed() -> void:
	editing = true
	Global.play_audio()
	queue_free()
