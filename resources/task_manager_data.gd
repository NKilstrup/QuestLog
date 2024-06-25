extends Resource
class_name TaskManagerData

const DATA_PATH := "user://"
const FILE_NAME := "_project_data.tres"

@export var save_data: Dictionary = {
	"default":
	[{"tab_name": "Not Started",
	"tab_color": Global.theme_accent_color,
	"tab_tasks": 
		[] 
		},
		{"tab_name": "In Progress",
	"tab_color": Global.theme_accent_color,
	"tab_tasks": 
		[] 
		},
		{"tab_name": "Finished",
	"tab_color": Global.theme_accent_color,
	"tab_tasks": 
		[] 
		}]
		,
	"top_bar_color": Global.theme_accent_color }

func create_project(name: String) -> void:
	var project: Array = [
		{"tab_name": "Not Started",
	"tab_color": Global.theme_accent_color,
	"tab_tasks": 
		[] 
		},
		{"tab_name": "In Progress",
	"tab_color": Global.theme_accent_color,
	"tab_tasks": 
		[] 
		},
		{"tab_name": "Finished",
	"tab_color": Global.theme_accent_color,
	"tab_tasks": 
		[] 
		}]
	
	save_data.clear()
	save_data[name] = project
	save_data["top_bar_color"] = Global.theme_accent_color
	write_data(name)

func write_data(project: String) -> void:
	ResourceSaver.save(self, DATA_PATH + project + FILE_NAME)
	#print("saved at: " + DATA_PATH + project + FILE_NAME)

static func load_data(project: String) -> TaskManagerData:
	var res:TaskManagerData
	if ResourceLoader.exists(DATA_PATH + project + FILE_NAME):
		#print("loaded at:" + DATA_PATH + project + FILE_NAME)
		return load(DATA_PATH + project + FILE_NAME)
	else:
		res = TaskManagerData.new()
		#print("created new load file")
		
	return res

		#GENERIC TEMPLATE
		#"tab_tasks": 
		#[{"task_title": "Generic Task",
		#"task_description": "Generic Task Description",
		#"task_color": Global.theme_accent_color,
		#"date_created": "00:00/ Monday/ 01/ January/ 2024",
		#"date_updated": "00:00/ Monday/ 01/ January/ 2024" }] 
