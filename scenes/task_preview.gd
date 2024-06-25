extends Control
class_name TaskPreview

@onready var task_panel: Panel = %TaskPanel
@onready var task_label: Label = %TaskLabel

func setup_preview(title: String, color: Color) -> void:
	await ready
	task_label.text = title
	task_panel.modulate = color
	theme = Global.active_theme_files
	
	if Global.label_settings.has("medium_label_settings"):
		task_label.label_settings = Global.label_settings["medium_label_settings"]
	
	if Global.active_theme == "atomic":
		task_label.modulate = color
	else:
		task_label.modulate = Color.WHITE
