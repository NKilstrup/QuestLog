extends GenericWindow

signal task_tab_updated(title: String, color: Color)

@onready var new_tab_label: Label = %NewTabLabel
@onready var text_edit: TextEdit = %TextEdit
@onready var color_label: Label = %ColorLabel
@onready var color_picker: ColorPickerButton = %ColorPickerButton
@onready var color_field_background: Panel = %ColorFieldBackground

@onready var accept_button: MarginContainer = %AcceptButton
@onready var cancel_button: MarginContainer = %CancelButton

var create_new: bool = true
var tab_color: Color

func _ready() -> void:
	Global.theme_font_color_changed.connect(setup_font)
	setup_color_picker()
	open_window()

func set_tab_title(title: String) -> void:
	text_edit.text = title
	new_tab_label.text = title

func set_tab_color(_color: Color, _color_picker_color: Color = Global.theme_accent_color) -> void:
	tab_color = _color
	color_picker.color = _color_picker_color
	setup_color(_color)
	blink()
	accept_button.setup_color(_color)
	accept_button.setup_font()
	cancel_button.setup_color(_color)
	cancel_button.setup_font()
	
	text_edit.add_theme_color_override("font_color", Global.theme_font_color)
	text_edit.add_theme_color_override("font_selected_color", Global.theme_font_color)
	text_edit.add_theme_color_override("font_placeholder_color", Global.theme_font_color)
	
	check_theme_coloring(Global.active_theme)

func check_theme_coloring(_theme: String) -> void:
	if _theme == "atomic":
		color_field_background.modulate = tab_color
		new_tab_label.modulate = tab_color
		color_label.modulate = tab_color
		text_edit.modulate = tab_color
	else:
		color_field_background.modulate = Color.WHITE
		new_tab_label.modulate = Color.WHITE
		color_label.modulate = Color.WHITE
		text_edit.modulate = Color.WHITE

func setup_font():
	if Global.label_settings.has("tab_title_label_settings"):
		new_tab_label.label_settings = Global.label_settings["tab_title_label_settings"]
	
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

func _on_accept_button_pressed() -> void:
	if text_edit.text.is_empty():
		text_edit.text = text_edit.placeholder_text
	
	if create_new:
		Global.new_task_tab_requested.emit(text_edit.text, color_picker.color)
	else:
		task_tab_updated.emit(text_edit.text, color_picker.color)
	
	Global.task_description_layer.hide()
	queue_free()

func _on_cancel_button_pressed() -> void:
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
