extends CharacterBody3D

@export var jumpImpulse : float = 2.0
@export var gravity : float = -5.0
@export var groundAcceleration : float = 30.0
@export var groundSpeedLimit : float = 3.5
@export var runAccel : float = 60
@export var runSpeedLimit : float = 5.0
@export var airAcceleration : float = 500.0
@export var airSpeedLimit : float = 0.5
@export var groundFriction : float = 0.9

@export var boing_freq : float = 2.4
@export var boing_amp : float = 0.08
@export var t_boing : float = 0.0

@export var mouseSensitivity : float = 0.1

@onready var paws_menu : Control = $YawAxis/Camera/paws_menu
@onready var stamina_t : Timer = $StaminaDur
var paused : bool = false
var running : bool = false

var restartTransform
var restartVelocity

func _ready():
	velocity = Vector3.ZERO
	paws_menu.hide()
	#process_mode = Node.PROCESS_MODE_PAUSABLE
	restartTransform = self.global_transform
	restartVelocity = self.velocity
	pass # Replace with function body.

func _physics_process(delta):
	# Apply gravity, jumping, and ground friction to velocity
	#print(velocity)
	velocity.y += gravity * delta
	if is_on_floor():
		# By using is_action_pressed() rather than is_action_just_pressed()
		# we get automatic bunny hopping.
		if Input.is_action_just_pressed("move_jump"):
			velocity.y = jumpImpulse
		else:
			velocity *= groundFriction
	
	# Compute X/Z axis strafe vector from WASD inputs
	var basis = $YawAxis/Camera.get_global_transform().basis
	var strafeDir = Vector3(0, 0, 0)
	if Input.is_action_pressed("move_forward"):
		strafeDir -= basis.z
	if Input.is_action_pressed("move_backward"):
		strafeDir += basis.z
	if Input.is_action_pressed("move_left"):
		strafeDir -= basis.x
	if Input.is_action_pressed("move_right"):
		strafeDir += basis.x
	strafeDir.y = 0
	strafeDir = strafeDir.normalized()
	
	#Separate Section for ui handling
	if Input.is_action_just_pressed("pause"):
		_pause_menu()

	# Figure out which strafe force and speed limit applies
	var strafeAccel = groundAcceleration if is_on_floor() else airAcceleration
	var speedLimit = groundSpeedLimit if is_on_floor() else airSpeedLimit
	
	if Input.is_action_pressed("move_run") and is_on_floor():
		strafeAccel = runAccel 
		speedLimit = runSpeedLimit
		#speedLimit = runSpeedLimit if is_on_floor() else airSpeedLimit

	#if Input.is_action_just_pressed("move_run") and not running:
		#print("running!")
		#running = true
		#stamina_t.start()
	#elif Input.is_action_just_pressed("move_run") and running:
		#print("walking!")
		#running = false

	#if running and is_on_floor():
		#strafeAccel = runAccel
		#speedLimit = runSpeedLimit
		
	# Project current velocity onto the strafe direction, and compute a capped
	# acceleration such that *projected* speed will remain within the limit.
	var currentSpeed = strafeDir.dot(velocity)
	var accel = strafeAccel * delta
	accel = max(0, min(accel, speedLimit - currentSpeed))
	
	# Apply strafe acceleration to velocity and then integrate motion
	velocity += strafeDir * accel
	move_and_slide()

	#if Input.is_action_just_released("move_run"):
		#velocity = -30 * basis.z
	
	#if Input.is_action_just_pressed("checkpoint"):
		#print("Saving Checkpoint: %s / %s" % [self.translation, self.velocity])
		#restartTransform = self.global_transform
		#restartVelocity = self.velocity	
	#
	#if Input.is_action_just_pressed("restart"):
		#self.global_transform = restartTransform
		#self.velocity = restartVelocity
	#
	pass

func _input(event):
	if event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$YawAxis.rotate_x(deg_to_rad(event.relative.y * mouseSensitivity * -1))
		self.rotate_y(deg_to_rad(event.relative.x * mouseSensitivity * -1))

		# Clamp yaw to [-89, 89] degrees so you can't flip over
		var yaw = $YawAxis.rotation_degrees.x
		$YawAxis.rotation_degrees.x = clamp(yaw, -89, 89)
		
func _pause_menu():
	if paused:
		paws_menu.hide()
		get_tree().paused = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		paws_menu.show()
	
	paused = !paused

func _on_stamina_dur_timeout():
	running = false
