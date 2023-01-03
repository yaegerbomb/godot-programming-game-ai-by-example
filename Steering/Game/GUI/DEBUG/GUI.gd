extends Control

class_name DebugGUI

var hide: bool = false

onready var tween = $DebugButtons/HideTween
onready var hidden_buttons = $ShowDebugButtonsButton
onready var debug_buttons = $DebugButtons
onready var pursue_toggle = $DebugButtons/MarginContainer/VList/PursueToggle

onready var original_position: Vector2



func _unhandled_key_input(event):
	if event.is_action_pressed("pursue"):
		_on_PursueToggle_pressed()
		pursue_toggle.pressed = !pursue_toggle.pressed
		
func _ready():
	original_position = debug_buttons.rect_global_position

func _on_PauseMovementToggle_toggled(_button_pressed):
	Signals.emit_on_movement_paused_toggled()

func _on_HideButton_pressed():
	print("debug_buttons.rect_global_position", debug_buttons.rect_global_position)
	tween.interpolate_property(
		debug_buttons, 
		"rect_position",
		debug_buttons.rect_global_position,
		Vector2(-debug_buttons.margin_right, 0), 
		0.2, 
		Tween.TRANS_LINEAR,Tween.EASE_OUT
	)
	tween.start()
	hidden_buttons.show()


func _on_ShowDebugButtonsButton_pressed():
	tween.interpolate_property(
		debug_buttons, 
		"rect_position",
		debug_buttons.rect_global_position,
		original_position, 
		0.2, 
		Tween.TRANS_LINEAR,Tween.EASE_IN
	)
	tween.start()
	hidden_buttons.hide()

func _on_PursueToggle_pressed():
	Signals.emit_on_pursue_toggled()
