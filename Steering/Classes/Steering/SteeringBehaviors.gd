extends Node

class_name SteeringBehaviors

export var WANDER_RAD: float = 1.2
export var WANDER_DISTANCE: float = 2.0
export var WANDER_JITTER_PER_SEC: float = 80.0
export var WAYPOINT_SEEK_DIST = 20
export var SLOW_RADIUS = 1
export var TURN_AROUND_COEFFICIENT = 0.5

static func calculate():
	pass

static func seek(vehicle, target_position: Vector3) -> Vector3:
	var desired_velocity: Vector3 = vehicle.global_translation.direction_to(target_position)
	desired_velocity = desired_velocity * vehicle.max_speed
	return desired_velocity - vehicle.velocity
	
static func flee(vehicle, target_position: Vector3) -> Vector3:
	var desired_velocity: Vector3 = target_position.direction_to(vehicle.global_translation)
	desired_velocity = desired_velocity * vehicle.max_speed
	return desired_velocity - vehicle.velocity
	
static func arrive(vehicle: KinematicBody, target_position: Vector3) -> Vector3:
	var to_target: Vector3 = target_position - vehicle.global_translation
	var distance = to_target.length()
	if distance > 0.2:
		var deceleration_tweaker = 0.3

		var speed  = distance / (deceleration_tweaker * 3)

		speed  = min(speed , vehicle.max_speed)

		var desired_velocity = to_target * speed  / distance

		return desired_velocity - vehicle.velocity

	return Vector3.ZERO
	
static func pursuit(vehicle, evader):
	var to_evader: Vector3 = evader.global_translation - vehicle.global_translation
	var relative_heading: float = vehicle.heading.dot(evader.heading)
	
	if (to_evader.dot(vehicle.heading) > 0) and (relative_heading < -0.95): # acos(.95) = 18deg
		var target = evader.global_translation
		return seek(vehicle, target)
		
	var look_ahead_time: float = to_evader.length() / (vehicle.max_speed + evader.velocity.length())
	
	# turn around time
	var to_evader_normalized = to_evader.normalized()
	var dot = vehicle.heading.dot(to_evader_normalized)
	look_ahead_time += (dot - 1) * -0.5 #TURN_AROUND_COEFFICIENT
	
	var target = evader.global_translation + evader.velocity * look_ahead_time

	return seek(vehicle, target)
	
static func offset_pursuit(vehicle, leader_vehicle, offset: Vector3):
	var world_offset_pos = leader_vehicle.to_global(offset)
	
	var to_offset = world_offset_pos - vehicle.global_translation
	
	var look_ahead_time = to_offset.length() / (vehicle.max_speed + leader_vehicle.velocity.length())
	
	return arrive(vehicle, world_offset_pos + leader_vehicle.velocity * look_ahead_time)

static func evade(vehicle, pursuer):
	var to_pursuer: Vector3 = pursuer.global_translation - vehicle.global_translation
	
	var look_ahead_time: float = to_pursuer.length() / (vehicle.max_speed + pursuer.velocity.length())
	var flee_target = pursuer.global_translation + pursuer.velocity * look_ahead_time
#	DebugDraw.draw_sphere(flee_target, 1, Color.red, vehicle.delta)
	return flee(vehicle, flee_target)
	
static func wander(vehicle: KinematicBody):
	randomize()
	var position = vehicle.global_translation
	var y = position.y

	var jitter_time_slice = vehicle.wander_jitter # * vehicle.delta
	vehicle.wander_target += Vector3(rand_range(-1, 1) * jitter_time_slice, y, rand_range(-1, 1) * jitter_time_slice)
	vehicle.wander_target = vehicle.wander_target.normalized()
	vehicle.wander_target *= vehicle.wander_radius
	vehicle.wander_target.y = y
	
	var local_target: Vector3 = vehicle.wander_target + Vector3(0, 0, -vehicle.wander_distance)
	local_target.y = y
#	DebugDraw.draw_sphere(local_target, .25, Color.purple, vehicle.delta)

	var true_target = vehicle.transform.xform(local_target)
	true_target.y = y
#	DebugDraw.draw_sphere(true_target, .25, Color.cyan,  vehicle.delta)
	return true_target - vehicle.global_translation

static func avoid_obstacles(vehicle):
	var obstacles = vehicle.obstacle_detection_box.get_overlapping_bodies()	
	
	var steering_force: Vector3
	
	for obstacle in obstacles:
		var z_vector = vehicle.global_transform.basis.z
		var relative_pos = obstacle.global_translation - vehicle.global_translation

		var dot = z_vector.dot(relative_pos)		
		
		var local_position = vehicle.to_local(obstacle.global_translation)
		
		if dot <= 0:
		
			var ray_cast: RayCast = vehicle.obstacle_raycast
			
			ray_cast.cast_to = local_position
		
			if ray_cast.is_colliding():
				var over_shoot: Vector3 = ray_cast.global_translation - ray_cast.get_collision_point()
				print("over_shoot", over_shoot)
				var closest_obstacle_normal = ray_cast.get_collision_normal()
				steering_force += closest_obstacle_normal * over_shoot.length()

	return steering_force

static func wall_avoidance(vehicle):
	var feelers: Array = [vehicle.front_feeler, vehicle.left_feeler, vehicle.right_feeler]

	var dist_to_closest_ip: float = 1.79769e308
	
	var closest_wall
	var closest_point: Vector3
	
	var steering_force: Vector3 = Vector3.ZERO
	
	var vehicle_position = vehicle.global_translation;
	for feeler in feelers:	
		if feeler.is_colliding():
			var wall = feeler.get_collider()
			if wall:
				var dist_to_this_ip = vehicle_position.distance_to(wall.global_translation)
				if dist_to_this_ip < dist_to_closest_ip:
					dist_to_closest_ip = dist_to_this_ip
					closest_wall = wall
					closest_point = feeler.get_collision_point()
					
		if closest_wall:
			var over_shoot: Vector3 = feeler.global_translation - closest_point
			var closest_wall_normal = feeler.get_collision_normal()
#			print("over_shoot", over_shoot)
#			print("closest_wall_normal", closest_wall_normal)
			steering_force = closest_wall_normal * over_shoot.length()
			print("steering_force", steering_force)
		
	return steering_force
	
static func interpose(vehicle, vehicle_a, vehicle_b):
	var vehicle_position: Vector3 = vehicle.global_translation
	var vehicle_a_position: Vector3 = vehicle_a.global_translation
	var vehicle_b_position: Vector3 = vehicle_b.global_translation
	var mid_point: Vector3 = (vehicle_a_position - vehicle_b_position) / 2.0
	
	var time_to_reach_midpoint: float = vehicle_position.distance_to(mid_point) / vehicle.max_speed
	
	var a_pos: Vector3 = vehicle_a_position + vehicle_a.velocity * time_to_reach_midpoint
	var b_pos: Vector3 = vehicle_b_position + vehicle_b.velocity * time_to_reach_midpoint
	
	mid_point = (a_pos + b_pos) / 2.0
	
	return arrive(vehicle, mid_point)
	
static func hide(vehicle, seeker_vehicle, obstacles):
	var vehicle_position = vehicle.global_translation
	var seeker_vehicle_position = seeker_vehicle.global_translation
	var dist_to_closest: float = 1.79769e308
	var best_hiding_spot: Vector3
	
	
	for obstacle in obstacles:
		var hiding_spot: Vector3 = get_hiding_position(obstacle.global_translation, obstacle.get_radius(), seeker_vehicle_position)
		
		var dist: float = hiding_spot.distance_squared_to(vehicle_position)
		
		if dist < dist_to_closest:
			dist_to_closest = dist
			best_hiding_spot = hiding_spot
			
	if dist_to_closest == 1.79769e308:
		return evade(vehicle, seeker_vehicle)
		
	return arrive(vehicle, best_hiding_spot)
	
static func get_hiding_position(pos_ob: Vector3, radius_ob: float, pos_target: Vector3):
	var distance_from_boundary = 3
	
	var dist_away = radius_ob + distance_from_boundary
	
	var to_ob: Vector3 = pos_target.direction_to(pos_ob)
	
	return (to_ob * dist_away) + pos_ob

static func follow_path(vehicle):
	var vehicle_position = vehicle.global_translation
	var dist_sqrd = vehicle.ai_path.current_waypoint.distance_squared_to(vehicle_position)
	
	if dist_sqrd < (vehicle.waypoint_seek_distance * vehicle.waypoint_seek_distance):
		vehicle.ai_path.set_next_waypoint()
	
	if !vehicle.ai_path.finished():
		return seek(vehicle, vehicle.ai_path.current_waypoint)
	else:
		return arrive(vehicle, vehicle.ai_path.current_waypoint)
