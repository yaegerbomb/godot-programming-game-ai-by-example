extends Vehicle

export (NodePath) var pursuit_target
export (Vector3) var offset

onready var pursuit_vehicle = get_node(pursuit_target)


func _physics_process(delta):
	var steering_force: Vector3 = SteeringBehaviors.offset_pursuit(self, pursuit_vehicle, offset)
	var acceleration: Vector3 = steering_force / mass
	velocity = velocity + acceleration * delta
	._physics_process(delta);
