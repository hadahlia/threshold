@tool
extends CharacterBody3D

var path = []
var path_ind = 0

@export var grid_map_path : NodePath 
@onready var grid_map : GridMap = get_node(grid_map_path)
#@onready var amap = get_parent()

const YUA : PackedScene = preload("res://scenes/yua_player.tscn")

@export var start : bool = false : set = set_start
const HERSPEED = 5

func set_start(val:bool)->void:
	if Engine.is_editor_hint():
		pass

func name_hard():
	#var t : int = 0
	#for cell in grid_map.get_used_cells():
		pass
		#var move_dir = (grid_map[cell] - global_transform.origin)
		#self.position = Vector3(cell) + Vector3(0.5,-0.2,0.5)
		#var cell_index : int = grid_map.get_cell_item(cell)
		#if cell_index <=2\
		#&& cell_index >=0:
			#pass


#var funny = grid_map.size()

func _ready():
	add_to_group("monter")
	
func _physics_process(delta):
		#astar.get_point_path(pos_from,pos_to)
		if path_ind < path.size():
			var move_dir = (path[path_ind] - self.position)
			if move_dir.length() < 0.1:
				path_ind += 1
			else:
				velocity += move_dir.normalized() * HERSPEED
				move_and_slide()
 
func move_to(target_pos):
	#path = grid_map.get_point_path(self.position, target_pos)
	path_ind = 0
