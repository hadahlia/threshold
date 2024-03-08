@tool
extends Node3D

@onready var grid_map : GridMap = $GridMap

@export var start : bool = false : set = set_start

func set_start(val: bool)->void:
	generate()

@export var boundary_size : int = 15 : set = set_dun_border

func set_dun_border(val : int)->void:
	boundary_size = val
	if Engine.is_editor_hint():
		visualize_boundary()

@export var room_count : int = 2
@export var room_margin : int = 1
@export var room_recursion : int = 10
@export var min_room_size : int = 2
@export var max_room_size : int = 6

var room_tiles : Array[PackedVector3Array] = []
var room_positions : PackedVector3Array = []

func visualize_boundary():
	grid_map.clear()
	for i in range(-1, boundary_size+1):
		grid_map.set_cell_item(Vector3i( i, 0, -1 ), 3)
		grid_map.set_cell_item(Vector3i( i, 0, boundary_size ), 3)
		grid_map.set_cell_item(Vector3i( boundary_size, 0, i ), 3)
		grid_map.set_cell_item(Vector3i( -1, 0, i ), 3)

func generate():
	room_tiles.clear()
	room_positions.clear()
	visualize_boundary()
	for i in room_count:
		make_room(room_recursion)
	print(room_positions)

func make_room(rec:int):
	if !rec>0:
		return
	
	var width : int = (randi() % (max_room_size - min_room_size)) + min_room_size
	var height : int = (randi() % (max_room_size - min_room_size)) + min_room_size
	
	var start_pos : Vector3i
	start_pos.x = randi() % (boundary_size - width +1)
	start_pos.z = randi() % (boundary_size - height +1)
	
	for r in range(-room_margin, height + room_margin):
		for c in range(-room_margin, width + room_margin):
			var pos : Vector3i = start_pos + Vector3i(c, 0, r)
			if grid_map.get_cell_item(pos) == 0:
				make_room(rec - 1)
				return
	
	var room : PackedVector3Array = []
	
	for r in height:
		for c in width:
			var pos : Vector3i = start_pos + Vector3i(c, 0, r)
			grid_map.set_cell_item(pos, 0)
			room.append(pos)
	room_tiles.append(room)
	var avg_x : float = start_pos.x + (float(width)/2)
	var avg_z : float = start_pos.z + (float(height)/2)
	var pos : Vector3 = Vector3(avg_x, 0, avg_z)
	room_positions.append(pos)
