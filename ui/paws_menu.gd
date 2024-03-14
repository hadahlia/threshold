extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$MarginContainer/VBoxContainer/p_resume_btn.grab_focus()
	#process_mode = Node.PROCESS_MODE_PAUSABLE
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_action_just_pressed("pause"):
		_on_p_resume_btn_pressed()


func _on_mouse_entered():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
func _on_mouse_exited():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_p_resume_btn_pressed():
	hide()
	get_tree().paused = false

func _on_p_quit_btn_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _on_p_settings_btn_pressed():
	pass # Replace with function body.
	



