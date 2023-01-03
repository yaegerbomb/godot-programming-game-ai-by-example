extends Vehicle

export (bool) var path_looped = false

onready var path: Path = get_node(path_path)


func _ready():	
	if path:
		ai_path.init(path.curve.get_baked_points(), path_looped)

func _physics_process(delta):
	var steering_force: Vector3 = SteeringBehaviors.follow_path(self)
	if steering_force != Vector3.ZERO:
		#steering_force = steering_force.limit_length(max_force) #SteeringBehaviors.clampedv3(steering_force, max_speed)
		var acceleration: Vector3 = steering_force / mass
		velocity = velocity + acceleration * delta
	else:
		velocity = Vector3.ZERO
		
	._physics_process(delta)
