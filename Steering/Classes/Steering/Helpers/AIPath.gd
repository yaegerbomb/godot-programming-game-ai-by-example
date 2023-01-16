extends Node

class_name AIPath

var waypoints: PoolVector3Array
var looped: bool
var current_waypoint: Vector3
var current_waypoint_index: int
	
func init(wps: Array, l: bool):
	waypoints = wps
	looped = l
	current_waypoint = wps[0]
	current_waypoint_index = 0
	
func get_path():
	return waypoints
	
func finished():
	return current_waypoint_index == (waypoints.size() - 1)
	
func set_next_waypoint():
	var waypoints_length = waypoints.size()
	if waypoints_length > 0:
		
		if current_waypoint_index >= (waypoints_length - 1):
			if looped:
				current_waypoint = waypoints[0]
				current_waypoint_index = 0
		else:
			current_waypoint_index += 1
			current_waypoint = waypoints[current_waypoint_index]

func _physics_process(delta):
	if waypoints.size() >= 2:
		DebugDraw.draw_point_path(waypoints, .25, Color.red, Color.red, delta)
