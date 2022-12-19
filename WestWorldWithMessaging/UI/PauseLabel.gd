extends RichTextLabel

export (NodePath) var ui_path


onready var ui: UIControl = get_node(ui_path)


# Called when the node enters the scene tree for the first time.
func _ready():
	ui.connect("console_paused", self, "on_console_pause")
	hide()


func on_console_pause(paused):
	if paused:
		show()
	else:
		hide()
