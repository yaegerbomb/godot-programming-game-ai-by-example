extends KinematicBody

class_name SoccerBall

export (Vector3) var velocity = Vector3.ZERO
export (float) var mass = 1.0
export (Vector3) var heading = Vector3.FORWARD
export (float) var friction = -0.015

onready var old_position
onready var player_owner

func get_radius():
	return $CollisionShape.shape.radius

func kick() -> void:
	pass

func time_to_cover_distance(from: Vector3, to: Vector3, force: float) -> float:
	var speed = force / mass
	var distance_to_cover: float = from.distance_to(to)
	var term: float = speed * speed + 2.0 * distance_to_cover * friction
	if term <= 0:
		return -1.0

	var v: float = sqrt(term)
	return (v - speed) / friction

func future_position(time: float) -> Vector3:
	var ut: Vector3 = velocity * time
	var half_a_t_squared: float = .5 * friction * time * time
	var scaler_to_vector: Vector3 = half_a_t_squared * velocity.normalized()
	return global_translation + ut + scaler_to_vector

func trap(new_owner: Vehicle) -> void:
	velocity = Vector3.ZERO
	player_owner = new_owner
	pass

func get_old_position() -> Vector3:
	return old_position

func play_at_position(new_position: Vector3) -> void:
	global_translation = new_position

func _on_CollisionArea_body_entered(body: Node):
	if body.is_in_group("Walls"):
		print("Wall Entered")
		pass

func _on_CollisionArea_area_entered(area):
	if area.is_in_group("Goals"):
		print("Goal Entered")
		pass
	elif area.is_in_group("Agents"):
		print("Agent Entere")
		pass
