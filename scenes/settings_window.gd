extends GenericWindow

@onready var resolution_selector: OptionButton = %ResolutionSelector
@onready var theme_selector: OptionButton = %ThemeSelector
@onready var color_picker: ColorPickerButton = %ColorPickerButton
@onready var volume_slider: HSlider = %VolumeSlider
@onready var sound_effects: CheckBox = %SoundEffects
@onready var top_bar_accent_color: CheckBox = %TopBarAccentColor
@onready var tabs_accent_color: CheckBox = %TabsAccentColor
@onready var tasks_accent_color: CheckBox = %TasksAccentColor
@onready var data_folder_panel: Panel = %DataFolderPanel
@onready var color_field_background: Panel = %ColorFieldBackground
@onready var file_path_button: Button = %FilePathButton

@onready var settings_label: Label = %SettingsLabel
@onready var resolution_label: Label = %ResolutionLabel
@onready var theme_label: Label = %ThemeLabel
@onready var color_label: Label = %ColorLabel
@onready var sfx_volume_label: Label = %SFXVolumeLabel
@onready var save_data_label: Label = %SaveDataLabel

@onready var accept_button: MarginContainer = %AcceptButton
@onready var cancel_button: MarginContainer = %CancelButton

var current_resolution: String
var window_color: Color

func _ready() -> void:
	setup_defaults()
	setup_resolution_selector()
	setup_theme_selector()
	setup_color_picker()
	open_window()
	setup_font()

func setup_defaults() -> void:
	color_picker.color = Global.theme_accent_color
	sound_effects.button_pressed = Global.sound_effects
	volume_slider.value = Global.sound_effects_volume

func setup_window_color(_color: Color = Global.theme_accent_color) -> void:
	window_color = _color
	setup_color(_color)
	blink()
	accept_button.setup_color(_color)
	cancel_button.setup_color(_color)
	check_theme_coloring(Global.active_theme, _color)

func setup_font():
	accept_button.setup_font()
	cancel_button.setup_font()
	
	theme_selector.add_theme_color_override("font_color", Global.theme_font_color)
	theme_selector.add_theme_color_override("font_pressed_color", Global.theme_font_color)
	resolution_selector.add_theme_color_override("font_color", Global.theme_font_color)
	resolution_selector.add_theme_color_override("font_pressed_color", Global.theme_font_color)
	
	top_bar_accent_color.add_theme_color_override("font_pressed_color", Global.theme_font_color)
	tabs_accent_color.add_theme_color_override("font_pressed_color", Global.theme_font_color)
	tasks_accent_color.add_theme_color_override("font_pressed_color", Global.theme_font_color)
	sound_effects.add_theme_color_override("font_pressed_color", Global.theme_font_color)

	top_bar_accent_color.add_theme_color_override("font_color", Global.theme_font_color)
	tabs_accent_color.add_theme_color_override("font_color", Global.theme_font_color)
	tasks_accent_color.add_theme_color_override("font_color", Global.theme_font_color)
	sound_effects.add_theme_color_override("font_color", Global.theme_font_color)
	
	if Global.label_settings.has("default_label_settings"):
		settings_label.label_settings = Global.label_settings["default_label_settings"]
	if Global.label_settings.has("button_label_settings"):
		resolution_label.label_settings = Global.label_settings["button_label_settings"]
		theme_label.label_settings = Global.label_settings["button_label_settings"]
	if Global.label_settings.has("small_label_settings"):
		color_label.label_settings = Global.label_settings["small_label_settings"]
		sfx_volume_label.label_settings = Global.label_settings["small_label_settings"]
		save_data_label.label_settings = Global.label_settings["small_label_settings"]

func check_theme_coloring(_theme: String, _color: Color = Global.theme_accent_color) -> void:
	var resolution_selector_popup := resolution_selector.get_popup()
	var theme_selector_popup := theme_selector.get_popup()
	
	var themeables: Array = [
		settings_label,
		theme_label,
		resolution_label,
		color_label,
		sfx_volume_label,
		color_field_background,  
		resolution_selector, 
		theme_selector, 
		volume_slider,
		sound_effects,
		top_bar_accent_color,
		tabs_accent_color,
		tasks_accent_color,
		data_folder_panel
		]
		
	if _theme == "atomic":
		for entry in themeables:
			entry.modulate = _color
			
		resolution_selector_popup.add_theme_color_override("font_color", _color)
		for index in resolution_selector.item_count:
			resolution_selector_popup.set_item_icon_modulate(index, _color)
		for background_panel: ScrollContainer in resolution_selector_popup.get_child(0, true).get_children():
			background_panel.self_modulate = _color
		
		theme_selector_popup.add_theme_color_override("font_color", _color)
		for index in theme_selector_popup.item_count:
			theme_selector_popup.set_item_icon_modulate(index, _color)
		for background_panel: ScrollContainer in theme_selector_popup.get_child(0, true).get_children():
			background_panel.self_modulate = _color
	else:
		for entry in themeables:
			entry.modulate = Color.WHITE
		
		resolution_selector_popup.add_theme_color_override("font_color", Global.theme_font_color)
		for index in resolution_selector.item_count:
			resolution_selector_popup.set_item_icon_modulate(index, Color.WHITE)
		for background_panel: ScrollContainer in resolution_selector_popup.get_child(0, true).get_children():
			background_panel.self_modulate = Color.WHITE
		
		theme_selector_popup.add_theme_color_override("font_color", Global.theme_font_color)
		for index in theme_selector_popup.item_count:
			theme_selector_popup.set_item_icon_modulate(index, Color.WHITE)
		for background_panel: ScrollContainer in theme_selector_popup.get_child(0, true).get_children():
			background_panel.self_modulate = Color.WHITE

func setup_color_picker() -> void:
	var picker = color_picker.get_picker()
	picker.color_mode = ColorPicker.MODE_RGB
	picker.picker_shape = ColorPicker.SHAPE_HSV_WHEEL
	picker.can_add_swatches = false
	picker.sampler_visible = false
	picker.color_modes_visible = false
	picker.sliders_visible = false
	picker.hex_visible = false
	picker.presets_visible = false
	var popup := color_picker.get_popup()
	popup.transparent_bg = true

func setup_resolution_selector() -> void:
	current_resolution = str(get_window().size.x, "x", get_window().size.y)
	if current_resolution not in Global.resolution_options:
		Global.resolution_options[current_resolution] = Vector2i(get_window().size.x, get_window().size.y)
	
	for index in Global.resolution_options:
		resolution_selector.add_item(index)
	
	var resolution_index: int = Global.resolution_options.keys().find(current_resolution)
	
	resolution_selector.select(resolution_index)

func setup_theme_selector() -> void:
	var themes: Array = Global.themes.keys()
	var iteration: int = 0
	for index in themes:
		theme_selector.add_item(index, iteration)
		iteration += 1
	
	var selected_theme: int = themes.find(Global.active_theme, 0)
	if selected_theme != -1:
		theme_selector.select(selected_theme)

func _on_accept_settings_pressed() -> void:
	var selected_resolution: String = resolution_selector.get_item_text(resolution_selector.selected)
	if selected_resolution != current_resolution:
		Global.change_resolution.emit(selected_resolution)

	if Global.active_theme != (theme_selector.get_item_text(theme_selector.selected)):
		Global.theme_changed.emit(theme_selector.get_item_text(theme_selector.selected))
	
	if color_picker.color != Global.theme_accent_color:
		Global.theme_accent_color = color_picker.color
		Global.theme_accent_color_changed.emit()
	
	if top_bar_accent_color.button_pressed:
		Global.recolor_top_bar.emit()
	
	if tabs_accent_color.button_pressed:
		Global.recolor_tabs.emit()
	
	if tasks_accent_color.button_pressed:
		Global.recolor_tasks.emit()
	
	Global.audio_settings_changed.emit(sound_effects.button_pressed, volume_slider.value)
	Global.sound_effects = sound_effects.button_pressed
	Global.sound_effects_volume = volume_slider.value
	
	Global.task_description_layer.hide()
	queue_free()

func _on_cancel_pressed() -> void:
	Global.task_description_layer.hide()
	queue_free()

func _on_file_path_button_pressed() -> void:
	var path = ProjectSettings.globalize_path("user://")
	OS.shell_open(path)

func _on_data_folder_panel_mouse_entered() -> void:
	
	if Global.active_theme == "atomic":
		var window_highlight_color: Color = window_color
		window_highlight_color.s = Global.highlight_color_saturation
		window_highlight_color.v = Global.highlight_color_value
		data_folder_panel.modulate = window_highlight_color
	else:
		data_folder_panel.modulate = Color(1.2, 1.2, 1.2)

func _on_data_folder_panel_mouse_exited() -> void:
	if Global.active_theme == "atomic":
		data_folder_panel.modulate = window_color
	else:
		data_folder_panel.modulate = Color(0.9, 0.9, 0.9)

func _on_color_picker_button_gui_input(event: InputEvent) -> void:
	if  event.is_action_pressed("shift_right_click"):
		color_picker_blink(Global.copied_color)
	elif event.is_action_pressed("right click"):
		Global.copied_color = color_picker.color
		color_picker_blink(color_picker.color)

func color_picker_blink(_color: Color) -> void:
	color_picker.color = Color.WHITE
	var tween := create_tween()
	tween.tween_property(color_picker, "color", _color, 0.2)
