extends Control

export (String) var scene_title = "Scene Title"

onready var scene_title_label = $CenterContainer/SceneTitleLabel

func _ready():
	scene_title_label.text = scene_title

func _on_ResetScene_pressed():
	get_tree().reload_current_scene()

func _on_Back_pressed():
	get_tree().change_scene("res://Game/Scenes/MainMenu/MainMenu.tscn")
