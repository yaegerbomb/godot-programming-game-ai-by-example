extends Camera

export (NodePath) var raycast_node_path

onready var raycast = get_node(raycast_node_path)

func _unhandled_input(event: InputEvent):
	if current:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				Signals.emit_click_position()
			elif event.button_index == BUTTON_RIGHT:
				Signals.emit_click_position()
			
			emit_click_position(event.position)
		elif event is InputEventMouseMotion:
			emit_on_mouse_move(event.position)
		
		
func emit_click_position(position: Vector2):
	var to = project_local_ray_normal(position) * 10000
	raycast.cast_to = to
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var point = raycast.get_collision_point()
		Signals.emit_on_left_click(point)

func emit_on_mouse_move(position: Vector2):
	var to = project_local_ray_normal(position) * 10000
	raycast.cast_to = to
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var point = raycast.get_collision_point()
		Signals.on_mouse_move(point)
