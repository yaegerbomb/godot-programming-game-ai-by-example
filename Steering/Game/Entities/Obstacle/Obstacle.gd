extends StaticBody

class_name Obstacle

var radius: float = 1.0 setget set_radius, get_radius

func _ready():
	radius *= scale.x
	pass

func set_radius(r: float):
	radius = r
	
func get_radius():
	return radius
