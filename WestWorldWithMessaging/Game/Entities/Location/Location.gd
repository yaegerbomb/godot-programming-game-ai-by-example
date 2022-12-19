extends BaseGameEntity

class_name Location

export (Enums.Locations) var location_key
export (Color) var color

# Called when the node enters the scene tree for the first time.
func _ready():
	var material = $Model.material
	material.albedo_color = color
	$NameLabel.text = name
	pass # Replace with function body.
	
