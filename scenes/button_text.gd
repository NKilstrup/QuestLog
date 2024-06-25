extends GenericButton

@onready var button_label: Label = $ButtonLabel

@export var button_title: String : set = setup_title

func _ready() -> void:
	Global.theme_changed.connect(check_theme_coloring)
	Global.theme_font_color_changed.connect(setup_font)
	check_theme_coloring(Global.active_theme)

func setup_title(title: String) -> void:
	await ready
	button_label.text = title

func setup_font():
	await get_tree().process_frame
	if Global.label_settings.has("button_label_settings"):
		button_label.label_settings = Global.label_settings["button_label_settings"]

func check_theme_coloring(_theme: String) -> void:
	if _theme == "atomic":
		button_label.modulate = button_color
	else:
		button_label.modulate = Color.WHITE
