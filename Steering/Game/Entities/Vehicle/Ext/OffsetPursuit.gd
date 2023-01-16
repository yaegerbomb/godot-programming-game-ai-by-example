extends Vehicle

export (NodePath) var pursuit_target
export (Vector3) var offset

func _ready():
	self.offset_pursuit_leader = get_node(pursuit_target)
	self.offset_pursuit_target = offset


func _physics_process(delta):
	var steering_force: Vector3 = SteeringBehaviors.offset_pursuit(self)
	var acceleration: Vector3 = steering_force / mass
	velocity = velocity + acceleration * delta
	._physics_process(delta);
