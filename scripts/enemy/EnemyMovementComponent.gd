class_name EnemyMovementComponent extends Node

signal reached_goal(goal: Node2D)

@export var repath_interval := 0.4
@export var direct_range := 40.0
@export var arrive_distance := 5.0
@export var prefer_crops := false


@export_group("Crop raid roll")
@export var roll_sides := 5
@export var winning_roll := 1
@export var max_crop_checks := 6
@export var raid_timeout := 20.0 # time to reach the crop

var player_range := 200.0
var pathfinder: GridPathfinder
var goal: Node2D # null means goal cant be reached or no goal at all
var raiding := false
var reached := false

var _path := PackedVector2Array()
var _index := 0
var _repath_timer := 0.0
var _last_target_cell := Vector2i(-99999, -99999)
var _last_rand_moved_angle := 0.0;
var _walk_timer := 0.0
var _plant_check_timer := 0.0
var _is_walking = false;
const walk_cd := 6.0;
const plant_check_interval := 5.0

@onready var body: CharacterBody2D = get_parent()

func _ready() -> void:
	pathfinder = get_tree().get_first_node_in_group("pathfinder")
	_repath_timer = randf() * repath_interval # repath on different frames
	_plant_check_timer = plant_check_interval

func get_direction(player: Node2D, delta: float) -> Vector2:
	if pathfinder == null:
		return body.global_position.direction_to(player.global_position)
	
	var player_in_range := body.global_position.distance_to(player.global_position) <= player_range
	
	if player_in_range:
		if raiding:
			end_raid()
		
		return _normal_step(player, delta)
		
	if raiding:
		return _raid_step(delta)

	# roll only while not raiding
	_plant_check_timer -= delta
	if _plant_check_timer <= 0.0:
		_plant_check_timer = plant_check_interval
		var roll := randi_range(1, roll_sides)
		var started := roll == winning_roll and _start_raid()
		#rolled.emit(roll, started)
		if started:
			return _raid_step(delta)

	return _normal_step(player, delta)

# normal behaviour: chase the player or wander
func _normal_step(player: Node2D, delta: float) -> Vector2:
	var to_player := player.global_position - body.global_position
	if to_player.length() > player_range:
		return get_random_direction(delta)
	if to_player.length() <= direct_range:
		return to_player.normalized()

	_repath_timer -= delta
	if _repath_timer <= 0.0:
		_repath_timer = repath_interval
		_path = pathfinder.find_path(body.global_position, player.global_position)
		_index = 1

	if _path.is_empty():
		return get_random_direction(delta)  # no route to the player
	_advance()
	if _index >= _path.size():
		return to_player.normalized()
	return body.global_position.direction_to(_path[_index])

# raid: walk to a crop
func _start_raid() -> bool:
	var best: Crop = null
	var best_path := PackedVector2Array()
	for crop in _closest_crops():
		var p := pathfinder.find_path_near(body.global_position, pathfinder.cell_to_world(crop.cell))
		if p.is_empty():
			continue
		if best == null or p.size() < best_path.size():
			best = crop
			best_path = p
	if best == null:
		return false # rolled the number, but no crop is reachable
	raiding = true
	goal = best
	_path = best_path
	_index = 1
	_walk_timer = 0.0
	reached = false
	_repath_timer = repath_interval
	return true

func _raid_step(delta: float) -> Vector2:
	if not is_instance_valid(goal): # harvested or destroyed on the way
		end_raid()
		return Vector2.ZERO

	_walk_timer += delta
	if raid_timeout > 0.0 and _walk_timer >= raid_timeout:
		end_raid()
		return Vector2.ZERO

	if reached:
		# break plant logic here later
		end_raid()
		return Vector2.ZERO

	_repath_timer -= delta
	if _repath_timer <= 0.0:
		_repath_timer = repath_interval
		var p := pathfinder.find_path_near(body.global_position, pathfinder.cell_to_world(goal.cell))
		if p.is_empty():
			end_raid()
			return Vector2.ZERO
		_path = p
		_index = 1

	_advance()
	if _index >= _path.size():
		reached = true
		reached_goal.emit(goal)
		return Vector2.ZERO
	return body.global_position.direction_to(_path[_index])

func end_raid() -> void:
	raiding = false
	goal = null
	reached = false
	_path = PackedVector2Array()
	_repath_timer = 0.0

func _advance() -> void:
	while _index < _path.size() and body.global_position.distance_to(_path[_index]) < arrive_distance:
		_index += 1

func _closest_crops() -> Array:
	var list := get_tree().get_nodes_in_group("crop").filter(
		func(n): return not n.is_queued_for_deletion())
	var origin := body.global_position
	list.sort_custom(func(a, b):
		return a.global_position.distance_squared_to(origin) < b.global_position.distance_squared_to(origin))
	return list.slice(0, max_crop_checks)
	
func get_random_direction(delta: float) -> Vector2:
	var angle := _last_rand_moved_angle

	_walk_timer -= delta
	if _walk_timer <= 0.0:
		_is_walking = not _is_walking
		
		if _is_walking:
			_walk_timer = randf_range(0.7, 1.5)
			angle = randf_range(-0.5 * PI, 0.5 * PI)

			if is_equal_approx(_last_rand_moved_angle, angle):
				angle += 0.5 * PI

			_last_rand_moved_angle = angle
		else:
			_walk_timer = walk_cd

	if not _is_walking:
		return Vector2.ZERO

	return Vector2.from_angle(angle)
