extends DebugGUI

export (NodePath) var agent_path

onready var agent = get_node(agent_path)

var left_drag: bool = false
var left_mouse_position_pressed: Vector3
var left_mouse_position_released: Vector3

var right_drag: bool = false
var right_mouse_position_pressed: Vector3
var right_mouse_position_released: Vector3

var mouse_position: Vector3

func _ready():
	update_labels()
	connect_signals()
	

func _physics_process(delta):
	mouse_position.y = agent.global_translation.y
	if left_drag:
		agent.global_translation = mouse_position
		update_labels()
		
	if right_drag:
		agent.look_at(mouse_position, Vector3.UP)
		agent.heading = agent.get_rotation()
		update_labels()

func update_labels():
	$DebugButtons/MarginContainer/VList/PositionContainer/HBoxContainer4/HBoxContainer/XValue.value = agent.global_translation.x
	$DebugButtons/MarginContainer/VList/PositionContainer/HBoxContainer4/HBoxContainer2/YValue.value = agent.global_translation.y
	$DebugButtons/MarginContainer/VList/PositionContainer/HBoxContainer4/HBoxContainer3/ZValue.value = agent.global_translation.z
	
	$DebugButtons/MarginContainer/VList/VelocityContainer/HBoxContainer4/HBoxContainer/VXValue.value = agent.velocity.x
	$DebugButtons/MarginContainer/VList/VelocityContainer/HBoxContainer4/HBoxContainer2/VYValue.value = agent.velocity.y
	$DebugButtons/MarginContainer/VList/VelocityContainer/HBoxContainer4/HBoxContainer3/VZValue.value = agent.velocity.z

func connect_signals():
	var error_code_left_click = Signals.connect("on_left_click", self, "on_left_click")
	if error_code_left_click != 0:
		print("ERROR: ", error_code_left_click)
		
		
	var error_code_right_click = Signals.connect("on_right_click", self, "on_right_click")
	if error_code_left_click != 0:
		print("ERROR: ", error_code_left_click)
		
	var error_code_left_click_release = Signals.connect("on_left_click_released", self, "on_left_click_released")
	if error_code_left_click_release != 0:
		print("ERROR: ", error_code_left_click_release)
		
	var error_code_right_click_release = Signals.connect("on_right_click_released", self, "on_right_click_released")
	if error_code_left_click_release != 0:
		print("ERROR: ", error_code_left_click_release)
		
	var error_code_mouse_move = Signals.connect("on_mouse_move", self, "on_mouse_move")
	if error_code_mouse_move != 0:
		print("ERROR: ", error_code_mouse_move)

func on_mouse_move(position: Vector3):
	mouse_position = position

func on_left_click(position: Vector3):
	print("left click at: ", position)
	left_mouse_position_pressed = position
	left_drag = true

func on_left_click_released(position: Vector3):
	print("left click released at: ", position)
	left_mouse_position_released = position
	left_drag = false

func on_right_click(position: Vector3):
	print("right click at: ", position)
	right_mouse_position_pressed = position
	right_drag = true
	
func on_right_click_released(position: Vector3):
	print("right click released at: ", position)
	right_mouse_position_released = position
	right_drag = false

func _on_XValue_value_changed(value):
	agent.global_translation.x = value

func _on_YValue_value_changed(value):
	agent.global_translation.y = value

func _on_ZValue_value_changed(value):
	agent.global_translation.z = value

func _on_VXValue_value_changed(value):
	agent.velocity.x = value

func _on_VYValue_value_changed(value):
	agent.velocity.y = value

func _on_VZValue_value_changed(value):
	agent.velocity.z = value
	var radians = deg2rad(value)
	var rotation_vector = Vector3(0,0,-1).rotated(Vector3(0, 1, 0), radians)
	agent.heading = rotation_vector
