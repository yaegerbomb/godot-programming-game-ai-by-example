extends Vehicle

onready var shark_detection_area = $SharkDetectionArea

func _physics_process(delta):	
	var sharks = shark_detection_area.get_overlapping_bodies()
	
	if sharks.size() > 0 :
		var closest_shark_distance: float =  1.79769e308
		for shark in sharks:
			var shark_distance: float = shark.global_translation.distance_to(self.global_translation)
			if shark_distance < closest_shark_distance:
				closest_shark_distance = shark_distance
				self.evade_vehicle = shark
	._physics_process(delta)

func _on_SharkDetectionArea_body_entered(_body):
	self.enable_steering_behavior(Enums.SteeringBehavior.Evade)


func _on_SharkDetectionArea_body_exited(_body):
	self.disable_steering_behavior(Enums.SteeringBehavior.Evade)
