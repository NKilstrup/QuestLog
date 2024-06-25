extends Control
class_name TaskManager

signal save_finished

const TASK_TAB: PackedScene = preload("res://scenes/task_tab.tscn")
const TASK: PackedScene = preload("res://scenes/task.tscn")

@onready var task_description_layer: ColorRect = %TaskDescriptionLayer
@onready var task_view: HBoxContainer = %TaskView
@onready var background: Panel = %Background
@onready var top_bar: MarginContainer = %TopBar
@onready var top_bar_container: MarginContainer = %TopBarContainer
@onready var window_bar: MarginContainer = %WindowBar
@onready var tab_corner_decorations: Control = %TabCornerDecorations
@onready var task_view_scroll_container: ScrollContainer = %TaskViewScrollContainer

var task_manager_data: TaskManagerData
var settings_data: SettingsData
var themes_data: Themes
var theme_constructor: ThemeConstructor = preload("res://resources/theme_constructor.gd").new()
var current_project: String

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	
	Global.create_project.connect(create_project)
	Global.remove_project.connect(remove_project)
	Global.switch_project.connect(switch_project)
	Global.rename_project.connect(rename_project)
	Global.new_task_tab_requested.connect(add_tab)
	Global.audio_settings_changed.connect(setup_audio)
	Global.theme_changed.connect(load_theme)
	Global.change_resolution.connect(setup_resolution)
	Global.task_description_layer = task_description_layer
	
	load_data()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save()
		await get_tree().process_frame
		get_tree().quit()

func load_data() -> void:
	if not dir_contents("user://").has("user://settings.tres"):
		if not dir_contents("user://").has("user://default_project_data.tres"):
			var default_project := TaskManagerData.load_data("default")
			default_project.write_data("default")
	
	settings_data = SettingsData.load_data()
	current_project = settings_data.current_project
	
	var screen_resolution := DisplayServer.screen_get_size()
	var current_resolution: String = settings_data.current_resolution
	if dir_contents("user://").has("user://settings.tres"):
		setup_resolution(current_resolution)
	elif not dir_contents("user://").has("user://settings.tres") and screen_resolution[0] < 1920:
		setup_resolution("1280x720")
	
	task_manager_data = TaskManagerData.load_data(current_project)
	themes_data = Themes.load_data()
	
	var active_theme = themes_data.get_theme(themes_data.active_theme)
	
	if not Global.projects.is_empty():
		Global.projects.clear()
	
	var projects: Array = dir_contents(task_manager_data.DATA_PATH)
	for entry: String in projects:
		if entry.contains("_project_data.tres"):
			var filename: String = entry.get_file()
			Global.projects.append(filename.get_slice("_", 0))
	
	Global.current_project = settings_data.current_project
	Global.theme_accent_color = settings_data.theme_accent_color
	Global.sound_effects = settings_data.sound_effects
	Global.sound_effects_volume = settings_data.sound_effects_volume
	Global.active_theme = themes_data.active_theme
	Global.themes = themes_data.themes
	
	top_bar.setup_color(task_manager_data.save_data["top_bar_color"])
	window_bar.setup_color(task_manager_data.save_data["top_bar_color"])
	
	setup_theme(active_theme)
	setup_audio(settings_data.sound_effects, settings_data.sound_effects_volume)
	generate_hierachy()
	Global.data_loaded.emit()

func setup_resolution(resolution: String) -> void:
	DisplayServer.window_set_size(Global.resolution_options[resolution])
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	DisplayServer.window_set_position(screen_center - window_size / 2)
	settings_data.current_resolution = resolution

func load_theme(_theme: String) -> void:
	themes_data.active_theme = _theme
	var active_theme = themes_data.get_theme(themes_data.active_theme)
	setup_theme(active_theme)
	Global.active_theme = _theme
	Global.themes = themes_data.themes

func setup_theme(_theme: Dictionary) -> void:
	var theme_texture: CompressedTexture2D = load(_theme["theme_texture"])
	var theme_font: Font = load(_theme["theme_font"])
	var theme_font_color: Color = _theme["theme_font_color"]
	Global.SOUND_CLICK = load(_theme["theme_click_sound"])
	Global.DROP_SOUND = load(_theme["theme_drop_sound"])
	
	var current_theme: Theme = theme_constructor.create_theme(theme_texture)
	Global.active_theme_files = current_theme
	theme = current_theme
	
	var scroll_container_style := StyleBoxEmpty.new()
	task_view_scroll_container.add_theme_stylebox_override("panel", scroll_container_style)
	
	setup_theme_font(theme_font, theme_font_color)

func setup_theme_font(font: Font = Global.theme_font, color: Color = Global.theme_font_color) -> void:
	Global.theme_font = font
	Global.theme_font_color = color
	theme.default_font = font
	
	var task_edit_button: StyleBoxTexture = load("res://resources/theme/styleboxes/button_task_edit.tres")
	task_edit_button.modulate_color = color
	var task_delete_button: StyleBoxTexture = load("res://resources/theme/styleboxes/button_task_delete.tres")
	task_delete_button.modulate_color = color
	
	var label_settings: Dictionary = theme_constructor.create_label_settings(color)
	Global.label_settings = label_settings
	Global.theme_font_color_changed.emit()

func generate_hierachy() -> void:
	var data: Array = task_manager_data.save_data[current_project]
	
	for tab in data.size():
		add_tab(data[tab]["tab_name"], data[tab]["tab_color"])
		
		for task in data[tab]["tab_tasks"].size():
			add_task(task_view.get_child(tab).task_container, 
					data[tab]["tab_tasks"][task]["task_title"],
					data[tab]["tab_tasks"][task]["task_description"],
					data[tab]["tab_tasks"][task]["task_color"],
					data[tab]["tab_tasks"][task]["date_created"], 
					data[tab]["tab_tasks"][task]["date_updated"])

func setup_audio(enabled: bool, volume: float) -> void:
	var bus_volume: float = lerp(-30.0, 0.0, clamp(volume * 0.01, 0, 1))
	AudioServer.set_bus_volume_db(0, bus_volume)
	if enabled:
		AudioServer.set_bus_mute(0, 0)
	elif not enabled:
		AudioServer.set_bus_mute(0, 1)

func save() -> void:
	settings_data.current_project = Global.current_project
	settings_data.theme_accent_color = Global.theme_accent_color
	settings_data.sound_effects = Global.sound_effects
	settings_data.sound_effects_volume = Global.sound_effects_volume
	settings_data.write_data()
	
	var data = gather_tab_data()
	task_manager_data.save_data.clear()
	task_manager_data.save_data[Global.current_project] = data
	task_manager_data.save_data["top_bar_color"] = top_bar.color
	task_manager_data.write_data(Global.current_project)
	
	themes_data.write_data()
	
	save_finished.emit()

func create_project(project: String) -> void:
	if project in Global.projects:
		return
	
	task_manager_data.create_project(project)
	Global.projects.append(project)

func remove_project(project: String) -> void:
	if project == current_project:
		print("Cannot remove active project!")
		return
	
	var projects_folder: Array = dir_contents(task_manager_data.DATA_PATH)
	for entry: String in projects_folder:
		if entry.contains(project + "_project_data.tres"):
			Global.projects.erase(project)
			var path = ProjectSettings.globalize_path(entry)
			OS.move_to_trash(path)

func switch_project(project: String) -> void:
	
	if project == current_project:
		return
	
	if project not in Global.projects:
		print("project doesn't exist in data files!")
		return
	
	save()
	
	current_project = project
	settings_data.current_project = project
	Global.current_project = project
	
	reset_task_view()
	await get_tree().process_frame
	
	task_manager_data = TaskManagerData.load_data(project)
	generate_hierachy()
	
	top_bar.setup_color(task_manager_data.save_data["top_bar_color"])
	window_bar.setup_color(task_manager_data.save_data["top_bar_color"])
	Global.project_switched.emit(project)

func rename_project(new_title: String, old_title: String) -> void:
	if new_title in Global.projects:
		print("A project with this title already exists!")
		return
	
	var old_project: TaskManagerData = TaskManagerData.load_data(old_title)
	var data: Array = old_project.save_data[old_title]
	var new_project: TaskManagerData = old_project.duplicate()
	new_project.save_data.clear()
	new_project.save_data[new_title] = data
	new_project.save_data["top_bar_color"] = old_project.save_data["top_bar_color"]
	
	new_project.write_data(new_title)
	
	if old_title == current_project:
		current_project = new_title
		Global.current_project = new_title
		reset_task_view()
		await get_tree().process_frame
		remove_project(old_title)
		
		task_manager_data = TaskManagerData.load_data(new_title)
		generate_hierachy()
	else:
		remove_project(old_title)
	
	Global.projects.erase(old_title)
	Global.projects.append(new_title)
	Global.project_renamed.emit(new_title, old_title)

func add_tab(title: String, color: Color) -> void:
	var new_tab = TASK_TAB.instantiate()
	task_view.add_child(new_tab)
	new_tab.update_tab(title, color)

func add_task(parent: Control, title: String, description: String, color: Color, date_created: String, date_updated: String):
	var new_task = TASK.instantiate()
	parent.add_child(new_task)
	new_task.setup_data(title, description, color, date_created, date_updated)

func _on_task_description_layer_gui_input(event: InputEvent) -> void:
	if task_description_layer.get_child_count() <= 0:
		return
		
	if event.is_action_pressed("left click") or event.is_action_pressed("right click"):
		for child in task_description_layer.get_children():
			if child is NewTaskWindow:
				child.task_not_edited.emit()
				child.queue_free()
				task_description_layer.hide()
			else:
				child.queue_free()
				task_description_layer.hide()

func reset_task_view() -> void:
	if task_view.get_children().is_empty():
		return
	
	for child in task_view.get_children():
		child.queue_free()

func gather_tab_data() -> Array:
	var tabs: Array = []
	
	for tab: TaskTab in task_view.get_children():
		
		var tab_tasks_data: Array = []
		
		for task: Task in tab.task_container.get_children():
			var task_data: Dictionary  = {}
			task_data["task_title"] = task.task_title
			task_data["task_description"] = task.task_description
			task_data["task_color"] = Color(task.task_color)
			task_data["date_created"] = task.date_created
			task_data["date_updated"] = task.date_updated
			tab_tasks_data.append(task_data)
		
		var tab_data: Dictionary  = {}
		tab_data["tab_name"] = tab.tab_name
		tab_data["tab_color"] = Color(tab.tab_color)
		tab_data["tab_tasks"] = tab_tasks_data
		
		tabs.append(tab_data)
	
	return tabs

func dir_contents(path: String) -> Array:
	var dir = DirAccess.open(path)
	var contents: Array = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				contents.append(path + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	return contents

func _on_task_description_layer_child_order_changed() -> void:
	if task_description_layer.get_children().is_empty():
		task_description_layer.hide()

func _on_task_view_child_order_changed() -> void:
	if not is_instance_valid(get_tree()):
		return
	for tab: TaskTab in task_view.get_children():
		tab.check_tab_decoration()
