extends Control

export (String) var scene_title = "Scene Title"

onready var scene_title_label = $CenterContainer/SceneTitleLabel

func _ready():
	scene_title_label.text = scene_title

func _on_ResetScene_pressed():
	var error_loading_scene = get_tree().reload_current_scene()
	if error_loading_scene:
		print("Error Loading Screen")


func _on_Back_pressed():
	var error_changing_scene = get_tree().change_scene("res://Game/Scenes/MainMenu/MainMenu.tscn")
	if error_changing_scene:
		print("Error Loading Screen")
