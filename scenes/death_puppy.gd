extends CollisionShape3D


func _on_trans_level_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	get_tree().current_scene.queue_free()
	var loadScreen := ResourceLoader.load("res://ui/loader_scene.tscn") as PackedScene
	var instancedScene := loadScreen.instantiate()
	get_tree().root.add_child(instancedScene)
	get_tree().current_scene = instancedScene
	
	#get_tree().change_scene_to_packed(loadScreen)
