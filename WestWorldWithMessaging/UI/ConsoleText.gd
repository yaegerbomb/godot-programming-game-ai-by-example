extends RichTextLabel


func _ready():
	Events.connect("print_message", self, "on_message_received")

func on_message_received(message: String, color: String = "#FFFFFF"):
	set_bbcode(bbcode_text + "\n[color=#%s]%s[/color]" % [color, message])
