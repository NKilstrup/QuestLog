extends MarginContainer

@onready var calendar_label: Label = %CalendarLabel

var time: Dictionary

func _ready() -> void:
	Global.project_switched.connect(change_current_project)
	Global.project_renamed.connect(change_current_project.unbind(1))
	time = Time.get_date_dict_from_system()
	set_current_project()
	set_current_time()

func set_current_project() -> void:
	await Global.data_loaded
	calendar_label.text = "Project: " + Global.current_project

func change_current_project(project: String) -> void:
	if project != Global.current_project:
		return
	
	calendar_label.text = "Project: " + project

func set_current_time() -> void:
	var month: String = set_calendar_month()
	var weekday: String = set_calendar_weekday()
	
	#calendar_label.text = weekday + "    " + month + "  " + str(time["day"]) + "    " + str(time["year"])
	Global.current_time.emit(month, weekday, str(time["day"]), str(time["year"]))

func set_calendar_month() -> String:
	match time["month"]:
		1:
			return "January"
		2:
			return "February"
		3:
			return "March"
		4:
			return "April"
		5:
			return "May"
		6:
			return "June"
		7:
			return "July"
		8:
			return "August"
		9:
			return "September"
		10:
			return "October"
		11:
			return "November"
		12:
			return "December"
		_:
			return ""

func set_calendar_weekday() -> String:
	match time["weekday"]:
		0:
			return "Sunday"
		1:
			return "Monday"
		2:
			return "Tuesday"
		3:
			return "Wednesday"
		4:
			return "Thursday"
		5:
			return "Friday"
		6:
			return "Saturday"
		_:
			return ""

func _on_left_button_pressed() -> void:
	var target_project: String
	var project_index: int = Global.projects.find(Global.current_project)
	if project_index > 0:
		target_project = Global.projects[project_index - 1]
	elif project_index == 0:
		target_project = Global.projects.back()
	
	Global.switch_project.emit(target_project)

func _on_right_button_pressed() -> void:
	var target_project: String
	var project_index: int = Global.projects.find(Global.current_project)
	if project_index < Global.projects.size() - 1:
		target_project = Global.projects[project_index + 1]
	elif project_index ==  Global.projects.size() - 1:
		if not Global.projects.is_empty():
			target_project = Global.projects.front()
	
	Global.switch_project.emit(target_project)
