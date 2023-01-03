extends Node

func _ready():
	var children = get_children()
	for child in children:
		child.queue_free()
	pass # Replace with function body.

