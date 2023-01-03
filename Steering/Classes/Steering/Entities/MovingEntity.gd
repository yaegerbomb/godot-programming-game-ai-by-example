extends BaseGameEntity

class_name MovingEntity

var _velocity: Vector3 setget set_velocity, get_velocity
var _acceleration: Vector3 setget set_acceleration, get_acceleration
var _mass: float setget set_mass, get_mass
var _heading: Vector3 setget set_heading, get_heading
var _side: Vector3 setget set_side, get_side
var _max_speed: float setget set_max_speed, get_max_speed
var _max_force: float setget set_max_force, get_max_force
var _max_turn_rate: float setget set_max_turn_rate, get_max_turn_rate

func set_velocity(new_velocity: Vector3) -> void:
	_velocity = new_velocity

func get_velocity() -> Vector3:
	return _velocity
	
func set_acceleration(new_acceleration: Vector3) -> void:
	_acceleration = new_acceleration
	
func get_acceleration() -> Vector3:
	return _acceleration

func set_mass(new_mass: float) -> void:
	_mass = new_mass

func get_mass() -> float:
	return _mass

func set_heading(new_heading: Vector3) -> void:
	_heading = new_heading

func get_heading() -> Vector3:
	return _heading
	
func set_side(new_side: Vector3) -> void:
	_side = new_side

func get_side() -> Vector3:
	return _side

func set_max_speed(new_max_speed: float) -> void:
	_max_speed = new_max_speed

func get_max_speed() -> float:
	return _max_speed

func set_max_force(new_max_force: float) -> void:
	_max_force = new_max_force

func get_max_force() -> float:
	return _max_force

func set_max_turn_rate(new_max_turn_rate: float) -> void:
	_max_turn_rate = new_max_turn_rate

func get_max_turn_rate() -> float:
	return _max_turn_rate

func init_moving_entity(
	id: int, 
	kinematic_body: KinematicBody,
	velocity: Vector3 = Vector3.ZERO, 
	mass: float = 1, 
	heading: Vector3 = Vector3.ZERO, 
	side: Vector3 = Vector3.ZERO, 
	max_speed: float = 0, 
	max_force: float = 0,
	max_turn_rate: float = 0
):
	set_id(id)
	set_velocity(velocity)
	set_mass(mass)
	set_heading(heading)
	set_side(side)
	set_max_speed(max_speed)
	set_max_force(max_force)
	set_max_turn_rate(max_turn_rate)
