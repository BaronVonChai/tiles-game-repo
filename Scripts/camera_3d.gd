extends Camera3D

var target_position = Vector3.ZERO
var camera_distance = 20.0
var min_distance = 5.0
var max_distance = 40.0
var rotation_speed = 0.01
var orbit_height = 10.0

var is_rotating = false

func _ready():
	# Initial position setup
	position = Vector3(camera_distance, orbit_height, 0)
	look_at(target_position)

func _process(delta):
	# Check for keyboard input as an alternative to mouse wheel
	if Input.is_action_pressed("ui_page_up"):
		camera_distance -= 0.5
		camera_distance = max(min_distance, camera_distance)
		update_camera_position()
		
	if Input.is_action_pressed("ui_page_down"):
		camera_distance += 0.5
		camera_distance = min(max_distance, camera_distance)
		update_camera_position()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			is_rotating = event.pressed
	
	elif event is InputEventMouseMotion and is_rotating:
		var offset = global_transform.origin - target_position
		var rotation_y = -event.relative.x * rotation_speed
		var new_offset = offset.rotated(Vector3.UP, rotation_y)
		
		global_transform.origin = target_position + new_offset
		
		look_at(target_position)
	
	if event is InputEventMouseButton:
		if event.button_index == 4:  # Wheel up
			camera_distance -= 2.0
			camera_distance = max(min_distance, camera_distance)
			update_camera_position()
			
		elif event.button_index == 5:  # Wheel down
			camera_distance += 2.0
			camera_distance = min(max_distance, camera_distance)
			update_camera_position()

func update_camera_position():
	var direction = (global_transform.origin - target_position).normalized()
	global_transform.origin = target_position + direction * camera_distance
	look_at(target_position)
