extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/start_btn.grab_focus()
	
func _on_mouse_entered():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
func _on_mouse_exited():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_start_btn_pressed()->void:
	var loadScreen : PackedScene = load("res://ui/loader_scene.tscn")
	get_tree().change_scene_to_packed(loadScreen)


func _on_quit_btn_pressed():
	get_tree().quit()


func _on_setting_btn_pressed():
	pass # Replace with function body.
