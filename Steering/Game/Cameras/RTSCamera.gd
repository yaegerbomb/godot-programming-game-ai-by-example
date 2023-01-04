extends Camera

onready var raycast = $RayCast

const lerp_speed = 7
const movement_change = .05
const zoom_change = .15

var movement_vector = Vector2.ZERO
var currently_rotating_camera = false
var fixed_toggle_point = Vector2.ZERO

func _unhandled_input(event):
	if current: 
		handle_panning()
		handle_mouse(event)

func _physics_process(_delta):
	var target = self.transform.origin + Vector3(movement_vector.x, 0, movement_vector.y)
	self.transform.origin = lerp(self.transform.origin, target, lerp_speed)
	
	
	# This happens once 'move_map' is pressed
	if Input.is_action_just_pressed("scroll_wheel_click"):
		var ref = get_viewport().get_mouse_position()
		fixed_toggle_point = ref
	# This happens while 'move_map' is pressed
	if Input.is_action_pressed('scroll_wheel_click'):
		slide_map_around()
		
func slide_map_around():
	var ref = get_viewport().get_mouse_position()
	print("(ref.y - fixed_toggle_point.y)", (ref.y - fixed_toggle_point.y))
	print("(ref.x - fixed_toggle_point.x)", (ref.x - fixed_toggle_point.x))
	rotation_degrees.y += (ref.x - fixed_toggle_point.x) / 80

func handle_mouse(event):
	if Input.is_action_just_pressed("left_click"):
		emit_left_click_position(event.position)
	elif Input.is_action_just_released("left_click"):
		emit_left_click_release_position(event.position)
	elif Input.is_action_just_pressed("right_click"):
		emit_right_click_position(event.position)
	elif Input.is_action_just_released("right_click"):
		emit_right_click_release_position(event.position)
	elif event is InputEventMouseMotion:
		emit_on_mouse_move(event.position)
	elif Input.is_action_just_pressed("scroll_wheel_up"):
		self.global_translation.y -= zoom_change
	elif Input.is_action_just_pressed("scroll_wheel_down"):
		self.global_translation.y += zoom_change

func handle_panning():
	if Input.is_action_pressed("pan_up"):
		movement_vector.y = -movement_change
	
	elif Input.is_action_pressed("pan_down"):
		movement_vector.y = movement_change
	else:
		movement_vector.y = 0

	if Input.is_action_pressed("pan_left"):
		movement_vector.x = -movement_change
	elif Input.is_action_pressed("pan_right"):
		movement_vector.x = movement_change
	else:
		movement_vector.x = 0


func emit_left_click_position(position: Vector2):
	var to = project_local_ray_normal(position) * 10000
	raycast.cast_to = to
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var point = raycast.get_collision_point()
		Signals.emit_on_left_click(point)
		

func emit_left_click_release_position(position: Vector2):
	var to = project_local_ray_normal(position) * 10000
	raycast.cast_to = to
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var point = raycast.get_collision_point()
		Signals.emit_on_left_click_released(point)		

func emit_right_click_position(position: Vector2):
	var to = project_local_ray_normal(position) * 10000
	raycast.cast_to = to
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var point = raycast.get_collision_point()
		Signals.emit_on_right_click(point)
		
func emit_right_click_release_position(position: Vector2):
	var to = project_local_ray_normal(position) * 10000
	raycast.cast_to = to
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var point = raycast.get_collision_point()
		Signals.emit_on_right_click_released(point)

func emit_on_mouse_move(position: Vector2):
	var to = project_local_ray_normal(position) * 10000
	raycast.cast_to = to
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var point = raycast.get_collision_point()
		Signals.on_mouse_move(point)
