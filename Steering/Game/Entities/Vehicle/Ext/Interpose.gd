extends Vehicle

export (NodePath) var vehicle_a_path
export (NodePath) var vehicle_b_path

onready var vehicle_a = get_node(vehicle_a_path)
onready var vehicle_b = get_node(vehicle_b_path)


func _physics_process(delta):
	
	var steering_force: Vector3 = SteeringBehaviors.interpose(self, vehicle_a, vehicle_b)
	if steering_force != Vector3.ZERO:
		#steering_force = steering_force.limit_length(max_force) #SteeringBehaviors.clampedv3(steering_force, max_speed)
		var acceleration: Vector3 = steering_force / mass
		velocity = velocity + acceleration * delta
	else:
		velocity = Vector3.ZERO
		
	._physics_process(delta)
		
