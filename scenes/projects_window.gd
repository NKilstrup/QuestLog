extends GenericWindow

const PROJECT_BUTTON: PackedScene = preload("res://scenes/button_project.tscn")
const EDIT_WINDOW: PackedScene = preload("res://scenes/text_dialogue.tscn")

@onready var projects_container: VBoxContainer = %ProjectsContainer
@onready var new_project_background: Panel = %NewProjectBackground
@onready var new_project_title: TextEdit = %NewProjectTitle
@onready var title_label: Label = %TitleLabel
@onready var new_project_button: GenericButton = %CreateProjectButton

var window_color: Color = Color.RED

func _ready() -> void:
	Global.project_renamed.connect(replace_project_button)
	Global.theme_font_color_changed.connect(setup_font)
	setup_color(window_color)
	setup_font_color()
	setup_font()
	setup_window()
	open_window()
	blink()

func _input(event):
	if new_project_title.has_focus():
		if event is InputEventKey and event.is_pressed():
			if event.key_label == KEY_ENTER:
				get_viewport().set_input_as_handled()

func setup_window():
	new_project_background.modulate = Color(0.8, 0.8, 0.8)
	new_project_button.setup_color(window_color)
	for project in Global.projects:
		create_project_button(project)

func setup_font_color() -> void:
	new_project_title.add_theme_color_override("font_color", Global.theme_font_color)
	new_project_title.add_theme_color_override("font_selected_color", Global.theme_font_color)
	new_project_title.add_theme_color_override("font_placeholder_color", Global.theme_font_color)
	
	check_theme_coloring(Global.active_theme)

func check_theme_coloring(_theme: String) -> void:
	if _theme == "atomic":
		new_project_title.modulate = window_color
		title_label.modulate = window_color
	else:
		new_project_title.modulate = Color.WHITE
		title_label.modulate = Color.WHITE

func setup_font():
	if Global.label_settings.has("default_label_settings"):
		title_label.label_settings = Global.label_settings["default_label_settings"]

func switch_project(project: String): 
	Global.switch_project.emit(project)
	Global.task_description_layer.hide()
	queue_free()

func create_project_button(title: String) -> void:
		var project_button = PROJECT_BUTTON.instantiate()
		projects_container.add_child(project_button)
		project_button.project_selector_button.button_label.text = title
		if title == Global.current_project:
			project_button.project_selector_button.setup_color(highlight_color)
			project_button.edit_button.setup_color(window_color)
			project_button.delete_button.setup_color(window_color)
		else:
			project_button.project_selector_button.setup_color(window_color)
			project_button.edit_button.setup_color(window_color)
			project_button.delete_button.setup_color(window_color)
		project_button.button_clicked.connect(switch_project.bind(title))

func replace_project_button(new_button: String, old_button: String) -> void:
	for button in projects_container.get_children():
		if button is ProjectButton:
			if button.old_title == old_button:
				button.queue_free()
				create_project_button(new_button)

func _on_new_project_button_pressed() -> void:
	if new_project_title.text.is_empty() or new_project_title.text == " ":
		return
	
	if new_project_title.text in Global.projects:
		for child in Global.task_description_layer.get_children():
			if child is TextDialogue:
				child.queue_free()
		
		var warning_window := EDIT_WINDOW.instantiate()
		warning_window.custom_theme_color = window_color
		Global.task_description_layer.add_child(warning_window)
		warning_window.text_field.text = "Warning: A project with this name already exists"
		warning_window.accept_button.visible = false
		warning_window.cancel_button.setup_color(window_color)
		warning_window.position = new_project_title.global_position
		warning_window.text_field.custom_minimum_size.x = 512
		return
	
	Global.create_project.emit(new_project_title.text)
	create_project_button(new_project_title.text)
	
	new_project_title.clear()

func _on_new_project_button_mouse_entered() -> void:
	new_project_background.modulate = Color.WHITE

func _on_new_project_button_mouse_exited() -> void:
	new_project_background.modulate = Color(0.8, 0.8, 0.8)
