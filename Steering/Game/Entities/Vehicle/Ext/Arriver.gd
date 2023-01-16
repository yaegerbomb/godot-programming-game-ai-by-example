extends Vehicle

var target_position: Vector3

func _ready():
	target_position = self.global_translation
	self.arrive_target = self.global_translation
	var error_code = Signals.connect("on_left_click", self, "on_left_click")
	if error_code != 0:
		print("ERROR: ", error_code)


func _physics_process(delta):
	var actual_target_position = Vector3(target_position.x, self.global_translation.y, target_position.z);
	self.arrive_target = actual_target_position
	self.steering_force = SteeringBehaviors.arrive(self)
	if self.steering_force != Vector3.ZERO:
		#steering_force = steering_force.limit_length(max_force) #SteeringBehaviors.clampedv3(steering_force, max_speed)
		var acceleration: Vector3 = self.steering_force / self.mass
		self.velocity = self.velocity + acceleration * delta
	else:
		self.velocity = Vector3.ZERO
		
	._physics_process(delta)
		
func on_left_click(position: Vector3):
	target_position = position
