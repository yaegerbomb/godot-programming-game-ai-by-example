extends KinematicBody

class_name Vehicle

export (Vector3) var velocity = Vector3.ZERO
export (float) var mass = 1.0
export (Vector3) var heading = Vector3.FORWARD
export (float) var max_speed = 2.0 #150
export (float) var max_force = 3.0 #400
export (float) var max_turn_rate = PI
export (float) var wander_radius = 4.0;
export (float) var wander_distance = 5.0;
export (float) var wander_jitter = 2.5;
export (float) var waypoint_seek_distance = 2.24
export (Enums.SummingMethod) var summing_method = Enums.SummingMethod.Prioritized
export (
	int,
	FLAGS,
	"Wall Avoidance",
	"Obstacle Avoidance",
	"Evade",
	"Flee",
	"Separation",
	"Alignment",
	"Cohesion",
	"Seek",
	"Arrive",
	"Wander",
	"Pursuit",
	"Offset Pursuit",
	"Hide",
	"Follow Path"
) var steering_behaviors

export (NodePath) var path_path
export (Color) var color = Color.darkgoldenrod

onready var obstacle_detection_area: DetectionArea = $ObstacleDetectionArea
onready var neighbor_detection_area: DetectionArea = $NeighborDetectionArea

# wall feelers
onready var front_feeler = $Feelers/Front
onready var left_feeler = $Feelers/Left
onready var right_feeler = $Feelers/Right
onready var ai_path = $AIPath
onready var obstacle_raycast = $ObstacleRaycast
onready var pursuit_vehicle: Vehicle
onready var evade_vehicle: Vehicle
onready var offset_pursuit_leader: Vehicle
onready var seeking_vehicle: Vehicle

var move_debug: bool = false
var delta: float = 0;
var wander_target: Vector3

var obstacles_in_view_range = {}

var steering_force: Vector3
var seek_target: Vector3
var flee_target: Vector3
var arrive_target: Vector3
var offset_pursuit_target: Vector3


func _ready():
	var model_material = $CollisionShape/Model.get_surface_material(0)
	model_material.albedo_color = color
	
	var direction_material = $CollisionShape/Model/Direction.get_surface_material(0)
	direction_material.albedo_color = color
	
	randomize()
	var theta: float = randf() * (PI * 2);
	wander_target = Vector3(wander_radius * cos(theta), global_translation.y, wander_radius * sin(theta))
	
	var error_code = Signals.connect("on_movement_paused_toggled", self, "on_movement_paused_toggled")
	if error_code != 0:
		print("ERROR: ", error_code)
	
func _physics_process(d):
	physics_process(d)

func physics_process(d):
	if(!move_debug):
		SteeringBehaviors.calculate(self)
		var acceleration = steering_force / mass
		velocity = velocity + acceleration * d
		velocity = velocity.limit_length(max_speed)
		velocity.y = 0
		velocity = move_and_slide(velocity, Vector3.UP)

	if velocity.length_squared() > .00000001:
		heading = velocity.normalized();
		heading.y = global_translation.y
		var look_at_vector = global_translation + heading;
		look_at_vector.y = global_translation.y
		look_at(look_at_vector, Vector3.UP)
	
	self.delta = d;
	var r = (velocity.length() / max_speed)
	obstacle_detection_area.set_radius(r)
	
func on_movement_paused_toggled():
	move_debug = !move_debug
	

func steering_behavior_enabled(behavior):
	var bitmask = 1
	bitmask = bitmask ^ behavior
	if steering_behaviors & behavior:
		return true
		
	return false
	
func enable_steering_behavior(behavior):
	steering_behaviors = steering_behaviors | behavior
	
func disable_steering_behavior(behavior):
	steering_behaviors = steering_behaviors & ~behavior
