extends Vehicle

func _physics_process(delta):
	var steering_force: Vector3 = SteeringBehaviors.alignment(self)

	steering_force = steering_force.limit_length(max_force)
	var acceleration: Vector3 = steering_force / mass
	velocity = velocity + acceleration * delta

	._physics_process(delta)
