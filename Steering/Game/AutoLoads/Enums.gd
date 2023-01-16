extends Node

enum SteeringBehavior {
	WallAvoidance = 1,
	ObstacleAvoidance = 2,
	Evade = 4, 
	Flee = 8,
	Separation = 16,
	Alignment = 32,
	Cohesion = 64,
	Seek = 128,
	Arrive = 256,
	Wander = 512,
	Pursuit = 1024,
	OffsetPursuit = 2048,
	Interpose = 4096,
	Hide = 8192,
	FollowPath = 16384
}

enum SummingMethod {
	WeightedAverage,
	Prioritized,
	Dithered	
}

enum Team {
	Red,
	Blue
}
