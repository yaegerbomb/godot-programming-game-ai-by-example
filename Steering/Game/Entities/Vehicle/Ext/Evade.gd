extends Vehicle

export (NodePath) var evade_target

func _ready():
	self.evade_vehicle = get_node(self.evade_target)

func _physics_process(delta):
		var steering_force: Vector3 = SteeringBehaviors.evade(self)
		var acceleration: Vector3 = steering_force / mass
		velocity = velocity + acceleration * delta
		._physics_process(delta);
		
