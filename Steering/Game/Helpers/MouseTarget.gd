extends Spatial


export (NodePath) var model_path

onready var model = get_node(model_path)


func _ready():			
	var error_code_left_click = Signals.connect("on_left_click", self, "on_left_click")
	if error_code_left_click != 0:
		print("ERROR: ", error_code_left_click)
		
	var error_code_right_click = Signals.connect("on_right_click", self, "on_right_click")
	if error_code_right_click != 0:
		print("ERROR: ", error_code_right_click)
	model.mesh.material.albedo_color = Color.green

func on_left_click(point: Vector3):
	transform.origin = point
	model.mesh.material.albedo_color = Color.green
	
func on_right_click(point: Vector3):
	model.mesh.material.albedo_color = Color.red
