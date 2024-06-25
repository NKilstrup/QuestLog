extends MarginContainer

@onready var task_container: VBoxContainer = %TaskContainer

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data == null:
		return false
	
	var can_drop: bool = data is Task
	return can_drop

func _drop_data(at_position: Vector2, data: Variant) -> void:
	Global.play_audio(Global.DROP_SOUND)
	var index: int 
	for task in task_container.get_children():
		if (task.position.y) <= at_position.y:
			index = task.get_index()
			if index == task_container.get_children().size() - 1:
				index += 1
	
	data.parent.remove_child(data)
	task_container.add_child(data)
	data.position = Vector2.ZERO
	data.parent = task_container
	data.visible = true
	
	task_container.move_child(data, index)
	
	if data is Task:
		data.set_task_color(data.task_color)
	
