extends Vehicle

func _ready():
	move_debug = true

# override physics - we dont want to move the vehicle just display the resulting vector
func physics_process(d):
	avoid_obstacles(d)
	velocity = velocity.limit_length(max_speed)
	heading.y = global_translation.y
	var look_at_vector = global_translation + heading;
	look_at_vector.y = global_translation.y
	
	self.delta = d;
	var r = (velocity.length() / max_speed)
	obstacle_detection_area.set_radius(r)

func avoid_obstacles(d):	
	var steering_force: Vector3 = SteeringBehaviors.avoid_obstacles(self)
	DebugDraw.draw_arrow_line(global_translation, global_translation + steering_force, Color.greenyellow, 5, d)
	var acceleration: Vector3 = steering_force / mass
	velocity = velocity + acceleration * d
