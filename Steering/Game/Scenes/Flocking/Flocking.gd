extends Spatial

export (int) var number_of_fish = 60
export (int) var number_of_sharks = 1

var shark_instancer = preload("res://Game/Entities/Vehicle/Ext/Shark/Shark.tscn")
var fish_instancer = preload("res://Game/Entities/Vehicle/Ext/Fish/Fish.tscn")


onready var spawn_area: Area = $SpawnArea
onready var spawn_shape: CylinderShape = $SpawnArea/CollisionShape.shape
onready var shark_parent = $Agents/Sharks
onready var fish_parent = $Agents/Fish


# Called when the node enters the scene tree for the first time.
func _ready():
	DebugDraw.create_fps_graph("FPS")
	var top_bounds: float = spawn_area.global_translation.z - spawn_shape.radius
	var right_bounds: float = spawn_area.global_translation.x + spawn_shape.radius
	var bottom_bounds: float = spawn_area.global_translation.z + spawn_shape.radius
	var left_bounds: float = spawn_area.global_translation.x - spawn_shape.radius
	
	var random_generator = RandomNumberGenerator.new()
	
	for _n in range(number_of_sharks):
		var shark = shark_instancer.instance()
		shark_parent.add_child(shark)
		random_generator.randomize()
		var x = random_generator.randf_range(left_bounds, right_bounds)
		var z = random_generator.randf_range(top_bounds, bottom_bounds)
		shark.global_translation = Vector3(x, 0, z)
		
	for _n in range(number_of_fish):
		var fish = fish_instancer.instance()
		fish_parent.add_child(fish)
		random_generator.randomize()
		var x = random_generator.randf_range(left_bounds, right_bounds)
		var z = random_generator.randf_range(top_bounds, bottom_bounds)
		fish.global_translation = Vector3(x, 0, z)
		
