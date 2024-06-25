extends MarginContainer
class_name TextDialogue

signal dialogue_accepted(text: String)

@onready var text_field: LineEdit = %TextField
@onready var accept_button: GenericButton = %AcceptButton
@onready var cancel_button: GenericButton = %CancelButton

var custom_theme_color: Color = Color.RED

func _ready() -> void:
	text_field.add_theme_color_override("font_color", Global.theme_font_color)
	text_field.add_theme_color_override("font_uneditable_color", Global.theme_font_color)
	
	scale = Vector2(0, 1)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
	
	check_theme_coloring(Global.active_theme)

func check_theme_coloring(_theme: String) -> void:
	if _theme == "atomic":
		text_field.modulate = custom_theme_color #Global.theme_accent_color
	else:
		text_field.modulate = Color.WHITE

func _on_accept_button_button_clicked() -> void:
	if text_field.text == "" or text_field.text == " ":
		return
	
	dialogue_accepted.emit(text_field.text)
	call_deferred("queue_free")

func _on_cancel_button_button_clicked() -> void:
	queue_free()
