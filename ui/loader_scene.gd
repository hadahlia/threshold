extends Control

var progress : Array = []
var sceneName : String
var scene_load_status : int = 0

func _ready():
	Global.FloorNum += 1
	Global.BoundUp += 2
	Global.RoomUp += 1
	sceneName = "res://dungeon_budgeter/dun_generator.tscn"
	ResourceLoader.load_threaded_request(sceneName)

func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName, progress)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var dunScene = ResourceLoader.load_threaded_get(sceneName)
		get_tree().change_scene_to_packed(dunScene)
