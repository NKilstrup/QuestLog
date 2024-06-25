extends GenericWindow
class_name TaskDescription

signal description_updated(new_description: String, date_edited: String)

const window_width_buffer: int = 200

@onready var task_title: Label = %TaskTitle
@onready var description_text: TextEdit = %DescriptionText
@onready var finish_updating_panel: HBoxContainer = %FinishUpdatingPanel
@onready var created_label: Label = %CreatedLabel
@onready var edited_label: Label = %EditedLabel

@onready var accept_button: MarginContainer = %AcceptButton
@onready var cancel_button: MarginContainer = %CancelButton

var task_description: String = ""
var task_color: Color = Color(0.078, 0.102, 0.129)
var date_edited: String

func _ready() -> void:
	Global.play_audio(Global.DROP_SOUND)
	finish_updating_panel.visible = false

func setup_description_window(title: String, description: String, _color: Color) -> void:
	set_description_title(title)
	set_description_text(description)
	set_description_color(_color)
	set_description_size_position()
	setup_font()
	open_window()

func set_description_title(title: String) -> void:
	task_title.text = title

func set_description_text(description: String) -> void:
	task_description = description
	description_text.text = description

func set_description_color(_color: Color) -> void:
	task_color = _color
	setup_color(_color)
	blink()
	accept_button.setup_color(_color)
	cancel_button.setup_color(_color)
	check_theme_coloring(Global.active_theme)

func check_theme_coloring(_theme: String) -> void:
	if _theme == "atomic":
		description_text.modulate = task_color
		task_title.modulate = task_color
		edited_label.modulate = task_color
		created_label.modulate = task_color
	else:
		description_text.modulate = Color.WHITE
		task_title.modulate = Color.WHITE
		edited_label.modulate = Color.WHITE
		created_label.modulate = Color.WHITE

func setup_font():
	accept_button.setup_font()
	cancel_button.setup_font()
	
	description_text.add_theme_color_override("font_color", Global.theme_font_color)
	description_text.add_theme_color_override("font_selected_color", Global.theme_font_color)
	description_text.add_theme_color_override("font_placeholder_color", Global.theme_font_color)
	
	if Global.label_settings.has("tab_title_label_settings"):
		task_title.label_settings = Global.label_settings["tab_title_label_settings"]
	if Global.label_settings.has("small_label_settings"):
		created_label.label_settings = Global.label_settings["small_label_settings"]
		edited_label.label_settings = Global.label_settings["small_label_settings"]

func set_description_size_position() -> void:
	var title_size: int = task_title.text.length() * 22 
	custom_minimum_size.x = clampi(title_size + window_width_buffer, 520, 1600)

func set_edited_label() -> void:
	var hours_minutes: String = Time.get_time_string_from_system()
	hours_minutes = hours_minutes.left(hours_minutes.length() - 3)
	
	date_edited = hours_minutes + "/ " + (Global.current_weekday + "/ " + Global.current_day + 
			 "/ " + Global.current_month + "/ " + Global.current_year)
	edited_label.text = date_edited

func _on_description_text_text_changed() -> void:
	finish_updating_panel.visible = true

func _on_accept_button_pressed() -> void:
	set_description_text(description_text.text)
	set_edited_label()
	description_updated.emit(description_text.text, date_edited)
	finish_updating_panel.visible = false

func _on_cancel_button_pressed() -> void:
	description_text.text = task_description
	finish_updating_panel.visible = false
