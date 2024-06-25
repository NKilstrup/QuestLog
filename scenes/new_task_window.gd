extends GenericWindow
class_name NewTaskWindow

signal task_created(title: String, description: String, color: Color)
signal task_not_edited

@onready var task_title: TextEdit = %TaskTitle
@onready var task_description: TextEdit = %TaskDescription
@onready var color_picker: ColorPickerButton = %ColorPickerButton
@onready var new_task_label: Label = %NewTaskLabel
@onready var color_field_background: Panel = %ColorFieldBackground
@onready var color_label: Label = %ColorLabel

@onready var accept_button: MarginContainer = %AcceptButton
@onready var cancel_button: MarginContainer = %CancelButton

var task_color: Color

func _ready() -> void:
	setup_color_picker()
	open_window()

func setup_defaults(title: String, description: String, _color: Color, color_picker_color: Color = Global.theme_accent_color) -> void:
	task_title.text = title
	task_description.text = description
	color_picker.color = color_picker_color
	setup_window_color(_color)
	setup_font()

func setup_window_color(_color: Color = Global.theme_accent_color) -> void:
	task_color = _color
	setup_color(_color)
	blink()
	accept_button.setup_color(_color)
	cancel_button.setup_color(_color)
	check_theme_coloring(Global.active_theme)

func check_theme_coloring(_theme: String) -> void:
	if _theme == "atomic":
		new_task_label.modulate = task_color
		color_field_background.modulate = task_color
		task_title.modulate = task_color
		task_description.modulate = task_color
		color_label.modulate = task_color
	else:
		new_task_label.modulate = Color.WHITE
		color_field_background.modulate = Color.WHITE
		task_title.modulate = Color.WHITE
		task_description.modulate = Color.WHITE
		color_label.modulate = Color.WHITE

func setup_font():
	accept_button.setup_font()
	cancel_button.setup_font()
	
	task_title.add_theme_color_override("font_selected_color", Global.theme_font_color)
	task_title.add_theme_color_override("font_color", Global.theme_font_color)
	task_description.add_theme_color_override("font_selected_color", Global.theme_font_color)
	task_description.add_theme_color_override("font_color", Global.theme_font_color)
	
	if Global.label_settings.has("tab_title_label_settings"):
		new_task_label.label_settings = Global.label_settings["tab_title_label_settings"]
	if Global.label_settings.has("small_label_settings"):
		color_label.label_settings = Global.label_settings["small_label_settings"]

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

func _on_create_task_pressed() -> void:
	if task_title.text.is_empty():
		task_title.text = task_title.placeholder_text

	if task_description.text.is_empty():
		task_description.text = task_description.placeholder_text
	
	task_created.emit(task_title.text, task_description.text, color_picker.color)
	Global.task_description_layer.hide()
	queue_free()

func _on_cancel_pressed() -> void:
	task_not_edited.emit()
	Global.task_description_layer.hide()
	queue_free()

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
