extends Node

class_name SteeringBehaviors

# Constants --------------------------------------------------------------------
export var WANDER_RAD: float = 1.2
export var WANDER_DISTANCE: float = 2.0
export var WANDER_JITTER_PER_SEC: float = 80.0
export var WAYPOINT_SEEK_DIST = 20
export var SLOW_RADIUS = 1
export var TURN_AROUND_COEFFICIENT = 0.5

# Calcuation Functions----------------------------------------------------------
static func accumulate_force(vehicle, force_to_add: Vector3) -> bool:
	var magnitude_so_far: float = vehicle.steering_force.length()
	var magnitude_remaining: float = vehicle.max_force - magnitude_so_far
	
	if magnitude_remaining <= 0.0:
		return false
		
	var magnitude_to_add: float = force_to_add.length()
	if magnitude_to_add < magnitude_remaining:
		vehicle.steering_force += force_to_add
	else:
		vehicle.steering_force += (force_to_add.normalized() * magnitude_remaining)
		
	return true

static func calculate(vehicle):
	vehicle.steering_force = Vector3.ZERO
	
	match vehicle.summing_method:
		Enums.SummingMethod.Prioritized:
			calculate_prioritized(vehicle)

static func calculate_prioritized(vehicle):
	var force: Vector3 = Vector3.ZERO
	
	if vehicle.steering_behavior_enabled(Enums.SteeringBehavior.WallAvoidance):
		force = wall_avoidance(vehicle)
		
		if !accumulate_force(vehicle, force):
			return
			
	
	if vehicle.steering_behavior_enabled(Enums.SteeringBehavior.ObstacleAvoidance):
		force = avoid_obstacles(vehicle)
		
		if !accumulate_force(vehicle, force):
			return
	
	if vehicle.steering_behavior_enabled(Enums.SteeringBehavior.Evade):
		force = evade(vehicle)
		
		if !accumulate_force(vehicle, force):
			return
	
	
	if vehicle.steering_behavior_enabled(Enums.SteeringBehavior.Flee):
		force = flee(vehicle)
		
		if !accumulate_force(vehicle, force):
			return
	
	if vehicle.steering_behavior_enabled(Enums.SteeringBehavior.Separation):
		force = separation(vehicle)
		
		if !accumulate_force(vehicle, force):
			return
	
	if vehicle.steering_behavior_enabled(Enums.SteeringBehavior.Alignment):
		force = alignment(vehicle)
		
		if !accumulate_force(vehicle, force):
			return
	
	if vehicle.steering_behavior_enabled(Enums.SteeringBehavior.Cohesion):
		force = cohesion(vehicle)
		
		if !accumulate_force(vehicle, force):
			return
	
	if vehicle.steering_behavior_enabled(Enums.SteeringBehavior.Seek):
		force = seek(vehicle)
		print("seeking", force)
		
		if !accumulate_force(vehicle, force):
			return
	
	if vehicle.steering_behavior_enabled(Enums.SteeringBehavior.Arrive):
		force = arrive(vehicle)
		
		if !accumulate_force(vehicle, force):
			return
	
	if vehicle.steering_behavior_enabled(Enums.SteeringBehavior.Wander):
		force = wander(vehicle)
		
		if !accumulate_force(vehicle, force):
			return
	
	if vehicle.steering_behavior_enabled(Enums.SteeringBehavior.Pursuit):
		force = pursuit(vehicle)
		
		if !accumulate_force(vehicle, force):
			return
	
	if vehicle.steering_behavior_enabled(Enums.SteeringBehavior.OffsetPursuit):
		force = offset_pursuit(vehicle)
		
		if !accumulate_force(vehicle, force):
			return
	
	if vehicle.steering_behavior_enabled(Enums.SteeringBehavior.Hide):
		force = hide(vehicle)
		
		if !accumulate_force(vehicle, force):
			return
	
	if vehicle.steering_behavior_enabled(Enums.SteeringBehavior.FollowPath):
		force = follow_path(vehicle)
		
		if !accumulate_force(vehicle, force):
			return

# ------------------------------------------------------------------------------

# Steering Functions------------------------------------------------------------
static func seek(vehicle) -> Vector3:
	var distance = vehicle.global_translation.distance_to(vehicle.seek_target)
	if distance > 0.1:
		var desired_velocity: Vector3 = vehicle.global_translation.direction_to(vehicle.seek_target)
		desired_velocity = desired_velocity * vehicle.max_speed
		return desired_velocity - vehicle.velocity
	return Vector3.ZERO

static func flee(vehicle) -> Vector3:
	var desired_velocity: Vector3 = vehicle.flee_target.direction_to(vehicle.global_translation)
	desired_velocity = desired_velocity * vehicle.max_speed
	return desired_velocity - vehicle.velocity

static func arrive(vehicle) -> Vector3:
	var to_target: Vector3 = vehicle.arrive_target - vehicle.global_translation
	var distance = to_target.length()
	if distance > 0.1:
		var deceleration_tweaker = 0.3

		var speed  = distance / (deceleration_tweaker * 3)

		speed  = min(speed , vehicle.max_speed)

		var desired_velocity = to_target * speed  / distance

		return desired_velocity - vehicle.velocity

	return Vector3.ZERO

static func pursuit(vehicle) -> Vector3:
	var evader = vehicle.pursuit_vehicle
	if evader:
		var to_evader: Vector3 = evader.global_translation - vehicle.global_translation
		var relative_heading: float = vehicle.heading.dot(evader.heading)
		
		if (to_evader.dot(vehicle.heading) > 0) and (relative_heading < -0.95): # acos(.95) = 18deg
			var target = evader.global_translation
			vehicle.seek_target = target
			return seek(vehicle)
			
		var look_ahead_time: float = to_evader.length() / (vehicle.max_speed + evader.velocity.length())
		
		# turn around time
		var to_evader_normalized = to_evader.normalized()
		var dot = vehicle.heading.dot(to_evader_normalized)
		look_ahead_time += (dot - 1) * -0.5 #TURN_AROUND_COEFFICIENT
		
		var target = evader.global_translation + evader.velocity * look_ahead_time
		vehicle.seek_target = target

		return seek(vehicle)

	return Vector3.ZERO

static func offset_pursuit(vehicle) -> Vector3:
	var leader_vehicle = vehicle.offset_pursuit_leader
	var offset: Vector3 = vehicle.offset_pursuit_target
	if leader_vehicle:
		var world_offset_pos = leader_vehicle.to_global(offset)
		
		var to_offset = world_offset_pos - vehicle.global_translation
		
		var look_ahead_time = to_offset.length() / (vehicle.max_speed + leader_vehicle.velocity.length())
		vehicle.arrive_target = world_offset_pos + leader_vehicle.velocity * look_ahead_time
		return arrive(vehicle)

	return Vector3.ZERO

static func evade(vehicle) -> Vector3:
	var pursuer = vehicle.evade_vehicle
	if pursuer:
		var to_pursuer: Vector3 = pursuer.global_translation - vehicle.global_translation
		
		var look_ahead_time: float = to_pursuer.length() / (vehicle.max_speed + pursuer.velocity.length())
		vehicle.flee_target = pursuer.global_translation + pursuer.velocity * look_ahead_time
	#	DebugDraw.draw_sphere(flee_target, 1, Color.red, vehicle.delta)
		return flee(vehicle)

	return Vector3.ZERO

static func wander(vehicle: KinematicBody) -> Vector3:
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

static func avoid_obstacles(vehicle) -> Vector3:
	var obstacles = vehicle.obstacle_detection_area.get_overlapping_bodies()
	
	var steering_force: Vector3 = Vector3.ZERO
	
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
				var closest_obstacle_normal = ray_cast.get_collision_normal()
				steering_force += closest_obstacle_normal * over_shoot.length()

	return steering_force

static func wall_avoidance(vehicle) -> Vector3:
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
			steering_force = closest_wall_normal * over_shoot.length()
		
	return steering_force

static func interpose(vehicle, vehicle_a, vehicle_b) -> Vector3:
	var vehicle_position: Vector3 = vehicle.global_translation
	var vehicle_a_position: Vector3 = vehicle_a.global_translation
	var vehicle_b_position: Vector3 = vehicle_b.global_translation
	var mid_point: Vector3 = (vehicle_a_position - vehicle_b_position) / 2.0
	
	var time_to_reach_midpoint: float = vehicle_position.distance_to(mid_point) / vehicle.max_speed
	
	var a_pos: Vector3 = vehicle_a_position + vehicle_a.velocity * time_to_reach_midpoint
	var b_pos: Vector3 = vehicle_b_position + vehicle_b.velocity * time_to_reach_midpoint
	
	mid_point = (a_pos + b_pos) / 2.0
	vehicle.arrive_target = mid_point
	
	return arrive(vehicle)

static func hide(vehicle) -> Vector3:
	if vehicle.seeking_vehicle:
		var obstacles = vehicle.obstacle_detection_area.get_overlapping_bodies()
		var vehicle_position = vehicle.global_translation
		var seeker_vehicle_position = vehicle.seeking_vehicle.global_translation
		var dist_to_closest: float = 1.79769e308
		var best_hiding_spot: Vector3
		
		for obstacle in obstacles:
			var hiding_spot: Vector3 = get_hiding_position(obstacle.global_translation, obstacle.get_radius(), seeker_vehicle_position)
			
			var dist: float = hiding_spot.distance_squared_to(vehicle_position)
			
			if dist < dist_to_closest:
				dist_to_closest = dist
				best_hiding_spot = hiding_spot
				
		if dist_to_closest == 1.79769e308:
			vehicle.evade_vehicle = vehicle.seeking_vehicle
			return evade(vehicle)
			
		vehicle.arrive_target = best_hiding_spot
		return arrive(vehicle)

	return Vector3.ZERO

static func get_hiding_position(pos_ob: Vector3, radius_ob: float, pos_target: Vector3):
	var distance_from_boundary = 3
	
	var dist_away = radius_ob + distance_from_boundary
	
	var to_ob: Vector3 = pos_target.direction_to(pos_ob)
	
	return (to_ob * dist_away) + pos_ob

static func follow_path(vehicle) -> Vector3:
	var vehicle_position = vehicle.global_translation
	var dist_sqrd = vehicle.ai_path.current_waypoint.distance_squared_to(vehicle_position)
	
	if dist_sqrd < (vehicle.waypoint_seek_distance * vehicle.waypoint_seek_distance):
		vehicle.ai_path.set_next_waypoint()
	
	if !vehicle.ai_path.finished():
		vehicle.seek_target = vehicle.ai_path.current_waypoint
		return seek(vehicle)
	else:
		vehicle.arrive_target = vehicle.ai_path.current_waypoint
		return arrive(vehicle)

# ------------------------------------------------------------------------------

# Flocking Functions -----------------------------------------------------------
static func separation(vehicle) -> Vector3:
	var neighbors = vehicle.neighbor_detection_area.get_overlapping_bodies()
	
	var steering_force: Vector3 = Vector3.ZERO
	
	for neighbor in neighbors:
		if neighbor != vehicle:
			var to_agent: Vector3 = vehicle.global_translation - neighbor.global_translation
			var to_agent_length: float = to_agent.length()
			var to_agent_normalized = to_agent.normalized()
			steering_force += to_agent_normalized / to_agent_length
			
	return steering_force

static func alignment(vehicle) -> Vector3:
	var neighbors = vehicle.neighbor_detection_area.get_overlapping_bodies()
	var average_heading: Vector3 = Vector3.ZERO
	var neighbor_count = 0
	
	for neighbor in neighbors:
		if neighbor != vehicle && neighbor != vehicle.evade_vehicle:
			average_heading += neighbor.heading
			neighbor_count += 1

	if neighbor_count > 0:
		average_heading /= neighbor_count
		average_heading -= vehicle.heading
		
	return average_heading

static func cohesion(vehicle) -> Vector3:
	var neighbors = vehicle.neighbor_detection_area.get_overlapping_bodies()
	var center_of_mass: Vector3 = Vector3.ZERO
	var steering_force: Vector3 = Vector3.ZERO
	
	var neighbor_count = 0
	
	for neighbor in neighbors:
		if neighbor != vehicle:
			center_of_mass += neighbor.global_translation
			neighbor_count += 1
			
	if neighbor_count > 0:
		center_of_mass /= neighbor_count
		vehicle.seek_target = center_of_mass
		steering_force = seek(vehicle)
		
	return steering_force
# ------------------------------------------------------------------------------
