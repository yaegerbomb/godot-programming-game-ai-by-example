extends Vehicle

var target_position: Vector3

func _ready():
	target_position = self.global_translation
	self.seek_target = self.global_translation
	var error_code = Signals.connect("on_left_click", self, "on_left_click")
	if error_code != 0:
		print("ERROR: ", error_code)


func _physics_process(delta):
	self.seek_target = Vector3(target_position.x, self.global_translation.y, target_position.z);
	var steering_force: Vector3 = SteeringBehaviors.seek(self)

	steering_force = steering_force.limit_length(max_force)
	var acceleration: Vector3 = steering_force / mass
	velocity = velocity + acceleration * delta

	._physics_process(delta)
		
func on_left_click(position: Vector3):
	target_position = position
