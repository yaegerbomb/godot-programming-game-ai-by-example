extends Vehicle


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
		var steering_force: Vector3 = SteeringBehaviors.wander(self)
		var acceleration: Vector3 = steering_force / mass
		velocity = velocity + acceleration * delta
		._physics_process(delta);
		
