class_name EnemyMovementComponent extends Node

@export var repath_interval := 0.4
@export var direct_range := 40.0

var pathfinder: GridPathfinder
var _path := PackedVector2Array()
var _index := 0
var _timer := 0.0
var _last_target_cell := Vector2i(-99999, -99999)

@onready var body: CharacterBody2D = get_parent()

func _ready() -> void:
	pathfinder = get_tree().get_first_node_in_group("pathfinder")
	_timer = randf() * repath_interval # repath on different frames

func get_direction(target: Node2D, delta: float) -> Vector2:
	var second_target := target.global_position - body.global_position
	
	if pathfinder == null or second_target.length() <= direct_range:
		return second_target.normalized()

	_timer -= delta
	var target_cell := pathfinder.world_to_cell(target.global_position)
	if _timer <= 0.0 and (target_cell != _last_target_cell or _index >= _path.size()):
		_timer = repath_interval
		_last_target_cell = target_cell
		_path = pathfinder.find_path(body.global_position, target.global_position)
		_index = 1

	if _index >= _path.size():
		return second_target.normalized() # no path

	var next := _path[_index]
	if body.global_position.distance_to(next) < 4.0:
		_index += 1
		if _index >= _path.size():
			return second_target.normalized()
			
		next = _path[_index]
	return body.global_position.direction_to(next)

#func find_nearest_poi()
