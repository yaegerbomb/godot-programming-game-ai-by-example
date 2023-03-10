extends Control

func _on_SeekSceneButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Seek/Seek.tscn")

func _on_FleeSceneButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Flee/Flee.tscn")

func _on_ArriveSceneButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Arrive/Arrive.tscn")

func _on_EvadeSceneButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Evade/Evade.tscn")
	
func _on_PursuitSceneButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Pursuit/Pursuit.tscn")

func _on_OffsetPursuitSceneButton_pressed():
	get_tree().change_scene("res://Game/Scenes/OffsetPursuit/OffsetPursuit.tscn")

func _on_WanderSceneButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Wander/Wander.tscn")

func _on_ObstacleAvoidanceSceneButton_pressed():
	get_tree().change_scene("res://Game/Scenes/ObstacleAvoidance/ObstacleAvoidance.tscn")

func _on_WallAvoidanceSceneButton_pressed():
	get_tree().change_scene("res://Game/Scenes/WallAvoidance/WallAvoidance.tscn")

func _on_HideSceneButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Hide/Hide.tscn")

func _on_FollowPathButton_pressed():
	get_tree().change_scene("res://Game/Scenes/FollowPath/FollowPath.tscn")

func _on_SeparationSceneButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Separation/Separation.tscn")

func _on_AlignmentSceneButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Alignment/Alignment.tscn")

func _on_CohesionSceneButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Cohesion/Cohesion.tscn")

func _on_FlockingSceneButton_pressed():
	get_tree().change_scene("res://Game/Scenes/Flocking/Flocking.tscn")
