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

export (NodePath) var path_path
export (Color) var color = Color.darkgoldenrod

onready var obstacle_detection_box: DetectionBox = $ObstacleDetectionBox

# wall feelers
onready var front_feeler = $Feelers/Front
onready var left_feeler = $Feelers/Left
onready var right_feeler = $Feelers/Right
onready var ai_path = $AIPath

var move_debug: bool = false
var delta: float = 0;
var wander_target: Vector3

var obstacles_in_view_range = {}

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
		avoid_walls(d)
		avoid_obstacles(d)
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
	obstacle_detection_box.set_radius(r)
	

func on_movement_paused_toggled():
	move_debug = !move_debug
	
func avoid_obstacles(d):	
	var steering_force: Vector3 = SteeringBehaviors.avoid_obstacles(self)
	var acceleration: Vector3 = steering_force / mass
	velocity = velocity + acceleration * d
	
func avoid_walls(d):
	var steering_force: Vector3 = SteeringBehaviors.wall_avoidance(self)
	var acceleration: Vector3 = steering_force / mass
	velocity = velocity + acceleration * d
