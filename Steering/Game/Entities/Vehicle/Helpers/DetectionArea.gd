extends Area

class_name DetectionArea

export (NodePath) var parent_body
onready var parent_body_node = get_node(parent_body)

onready var collision_shape: CollisionShape = $CollisionShape

func set_radius(r: float):
	collision_shape.shape.radius = r

func get_radius():
	return collision_shape.shape.radius
	
func get_height():
	return collision_shape.shape.height
