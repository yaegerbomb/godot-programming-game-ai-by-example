extends Vehicle

func _physics_process(delta):
	steering_force += SteeringBehaviors.alignment(self)

	steering_force = steering_force.limit_length(max_force)
	var acceleration: Vector3 = steering_force / mass
	velocity = velocity + acceleration * delta

	._physics_process(delta)
