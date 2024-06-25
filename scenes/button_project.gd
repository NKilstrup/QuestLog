extends MarginContainer
class_name ProjectButton

const EDIT_WINDOW: PackedScene = preload("res://scenes/text_dialogue.tscn")

signal button_clicked

@onready var project_selector_button: MarginContainer = %ProjectSelectorButton
@onready var small_buttons_container: VBoxContainer = %SmallButtonsContainer
@onready var edit_button: GenericButton = %EditButton
@onready var delete_button: GenericButton = %DeleteButton

var old_title: String = ""

func _ready() -> void:
	project_selector_button.setup_font()

func change_project_title(new_title: String) -> void:
	if old_title == "":
		return
	
	Global.rename_project.emit(new_title, old_title)

func delete_project() -> void:
	Global.remove_project.emit(project_selector_button.button_label.text)
	queue_free()

func _on_project_selector_button_button_clicked() -> void:
	button_clicked.emit()

func _on_delete_button_pressed() -> void:
	for child in Global.task_description_layer.get_children():
		if child is TextDialogue:
			child.queue_free()
	
	var warning_window := EDIT_WINDOW.instantiate() as TextDialogue
	warning_window.custom_theme_color = edit_button.button_color
	Global.task_description_layer.add_child(warning_window)
	if project_selector_button.button_label.text == Global.current_project:
		warning_window.text_field.text = "Warning: Cannot delete active project"
		warning_window.accept_button.visible = false
		warning_window.cancel_button.setup_color(edit_button.button_color)
	else:
		warning_window.text_field.text = "Warning: delete this project?"
	warning_window.text_field.editable = false
	warning_window.text_field.custom_minimum_size.x = 320
	warning_window.position = edit_button.global_position - Vector2(warning_window.size.x, 0.0)
	warning_window.accept_button.setup_color(edit_button.button_color)
	warning_window.cancel_button.setup_color(edit_button.button_color)
	warning_window.dialogue_accepted.connect(delete_project.unbind(1))

func _on_edit_button_pressed() -> void:
	for child in Global.task_description_layer.get_children():
		if child is TextDialogue:
			child.queue_free()
	
	old_title = project_selector_button.button_label.text
	
	var edit_window := EDIT_WINDOW.instantiate() as TextDialogue
	edit_window.custom_theme_color = edit_button.button_color
	Global.task_description_layer.add_child(edit_window)
	edit_window.position = edit_button.global_position - Vector2(edit_window.size.x, 0.0)
	edit_window.text_field.text = project_selector_button.button_label.text
	edit_window.accept_button.setup_color(edit_button.button_color)
	edit_window.cancel_button.setup_color(edit_button.button_color)
	edit_window.dialogue_accepted.connect(change_project_title)
