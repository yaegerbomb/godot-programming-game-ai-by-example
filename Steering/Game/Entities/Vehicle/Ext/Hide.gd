extends Vehicle

export (NodePath) var seeker_path

func _ready():
	self.seeking_vehicle = get_node(seeker_path)
	pass # Replace with function body.


func _physics_process(delta):	
	var steering_force: Vector3 = SteeringBehaviors.hide(self)
	if steering_force != Vector3.ZERO:
		#steering_force = steering_force.limit_length(max_force) #SteeringBehaviors.clampedv3(steering_force, max_speed)
		var acceleration: Vector3 = steering_force / mass
		velocity = velocity + acceleration * delta
	else:
		velocity = Vector3.ZERO
		
	._physics_process(delta)
	
	pass
