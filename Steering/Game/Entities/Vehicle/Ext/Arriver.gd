extends Vehicle

var target_position: Vector3

func _ready():
	target_position = self.global_translation
	var error_code = Signals.connect("on_left_click", self, "on_left_click")
	if error_code != 0:
		print("ERROR: ", error_code)


func _physics_process(delta):
	var actual_target_position = Vector3(target_position.x, global_translation.y, target_position.z);
	var steering_force: Vector3 = SteeringBehaviors.arrive(self, actual_target_position)
	if steering_force != Vector3.ZERO:
		#steering_force = steering_force.limit_length(max_force) #SteeringBehaviors.clampedv3(steering_force, max_speed)
		var acceleration: Vector3 = steering_force / mass
		velocity = velocity + acceleration * delta
	else:
		velocity = Vector3.ZERO
		
	._physics_process(delta)
		
func on_left_click(position: Vector3):
	target_position = position
