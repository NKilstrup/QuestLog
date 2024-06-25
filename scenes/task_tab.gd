extends GenericWindow
class_name TaskTab

const NEW_TASK_WINDOW: PackedScene = preload("res://scenes/new_task_window.tscn")
const TASK_SCENE: PackedScene = preload("res://scenes/task.tscn")
const UPDATE_TAB_WINDOW: PackedScene = preload("res://scenes/new_tab_window.tscn")
const WARNING_WINDOW: PackedScene = preload("res://scenes/text_dialogue.tscn")
const MIN_DECORATION_SPACE: int = 512

@onready var tab_title: Label = %TabTitle
@onready var task_container: VBoxContainer = %TaskContainer
@onready var new_task_background: Panel = %NewTaskBackground
@onready var new_task_label: Label = %NewTaskLabel
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var scroll_container_background: Panel = %ScrollContainerBackground
@onready var task_section_header: MarginContainer = %TaskSectionHeader
@onready var tab_decorations: HBoxContainer = %TabDecorations
@export var tab_name: String = "Generic Tab"

var tab_color: Color = Global.theme_accent_color
var parent: Control
var custom_label_settings: LabelSettings

func _ready() -> void:
	Global.recolor_tabs.connect(set_tab_color)
	Global.theme_changed.connect(check_theme_coloring)
	Global.theme_font_color_changed.connect(setup_font)
	set_tab_title(tab_name)
	parent = get_parent()

func set_tab_title(title: String) -> void:
	tab_name = title
	tab_title.text = tab_name

func update_tab(title: String, _color: Color) -> void:
	set_tab_title(title)
	setup_font()
	set_tab_color(_color)

func update_and_save_tab(title: String, _color: Color) -> void:
	update_tab(title, _color)

func set_tab_color(_color: Color = Global.theme_accent_color) -> void:
	tab_color = _color
	
	var scroll_container_style := StyleBoxEmpty.new()
	scroll_container.add_theme_stylebox_override("panel", scroll_container_style)
	
	setup_color(tab_color)
	blink()
	
	task_section_header.tab_color = color
	task_section_header.set_buttons_color()
	task_section_header.disable_buttons()
	
	check_theme_coloring(Global.active_theme)

func check_theme_coloring(_theme: String) -> void:
	if _theme == "atomic":
		new_task_label.label_settings.font_color = inactive_color
		new_task_background.modulate = inactive_color
		tab_title.modulate = tab_color
		scroll_container_background.self_modulate = inactive_color
	else:
		new_task_background.modulate = Color(0.8, 0.8, 0.8)
		scroll_container_background.self_modulate = Color.WHITE
		tab_title.modulate = Color.WHITE

func setup_font() -> void:
	if Global.label_settings.has("tab_title_label_settings"):
		tab_title.label_settings = Global.label_settings["tab_title_label_settings"]

	if Global.label_settings.has("medium_label_settings"):
		new_task_label.label_settings = Global.label_settings["medium_label_settings"].duplicate()

func check_tab_decoration() -> void:
	await get_tree().process_frame
	tab_decorations.visible = size.x > MIN_DECORATION_SPACE

func _on_tab_delete_button_pressed() -> void:
	var warning_window := WARNING_WINDOW.instantiate()
	warning_window.custom_theme_color = tab_color
	Global.task_description_layer.add_child(warning_window)
	Global.task_description_layer.show()
	warning_window.text_field.text = "Warning: delete this tab?"
	warning_window.text_field.editable = true
	warning_window.text_field.selecting_enabled = false
	warning_window.text_field.mouse_filter = Control.MOUSE_FILTER_IGNORE
	warning_window.text_field.custom_minimum_size.x = 260
	warning_window.position = get_global_mouse_position() - Vector2(warning_window.size.x + 48, 24)
	warning_window.accept_button.setup_color(tab_color)
	warning_window.cancel_button.setup_color(tab_color)
	warning_window.dialogue_accepted.connect(queue_free.unbind(1))

func _on_new_task_button_pressed() -> void:
	Global.play_audio()
	var new_task_window = NEW_TASK_WINDOW.instantiate()
	Global.task_description_layer.add_child(new_task_window)
	Global.task_description_layer.show()
	new_task_window.setup_defaults("Task Title", "Task Description", tab_color, Global.theme_accent_color)
	new_task_window.task_created.connect(_create_new_task)

func _create_new_task(title: String, description: String, _color: Color) -> void:
	var new_task = TASK_SCENE.instantiate()
	task_container.add_child(new_task)
	new_task.update_task(title, description, _color)
	Global.task_description_layer.hide()

func _on_tab_edit_button_pressed() -> void:
	var update_tab_window = UPDATE_TAB_WINDOW.instantiate()
	Global.task_description_layer.add_child(update_tab_window)
	Global.task_description_layer.show()
	update_tab_window.create_new = false
	update_tab_window.set_tab_title(tab_name)
	update_tab_window.set_tab_color(tab_color, tab_color)
	update_tab_window.setup_font()
	update_tab_window.task_tab_updated.connect(update_and_save_tab)

func _on_move_left_button_pressed() -> void:
	var tab_index: int = self.get_index()
	if tab_index > 0:
		parent.move_child(self, tab_index - 1)
	
func _on_move_right_button_pressed() -> void:
	var tab_index: int = self.get_index()
	if tab_index < parent.get_children().size():
		parent.move_child(self, tab_index + 1)

func _on_new_task_mouse_entered() -> void:
	if Global.active_theme == "atomic":
		new_task_background.modulate = tab_color
		new_task_label.label_settings.font_color = tab_color
	else:
		new_task_background.modulate = Color(1.1, 1.1, 1.1)

func _on_new_task_mouse_exited() -> void:
	if Global.active_theme == "atomic":
		new_task_background.modulate = inactive_color
		new_task_label.label_settings.font_color = inactive_color
	else:
		new_task_background.modulate = Color(0.8, 0.8, 0.8)
