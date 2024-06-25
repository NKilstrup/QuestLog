extends Button

const NEW_TAB_WINDOW: PackedScene = preload("res://scenes/new_tab_window.tscn")

func _on_new_tab_button_pressed() -> void:
	Global.play_audio(Global.SOUND_CLICK)
	
	var new_tab_window = NEW_TAB_WINDOW.instantiate()
	Global.task_description_layer.add_child(new_tab_window)
	Global.task_description_layer.show()
	new_tab_window.set_tab_color(Global.theme_accent_color)
	new_tab_window.position = get_window().size / 2 - Vector2i(new_tab_window.size.x / 2, new_tab_window.size.y / 2)
