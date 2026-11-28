class_name EnemySpawner extends Node

@export var enemy_scene: PackedScene
@export var pool: Array[EnemyData]
@export var enemies_root: Node2D
@export var player: Node2D
@export var max_alive := 6
@export var spawn_distance := 350.0
@export var interval := 4.0
@export var bounds: MapBounds
@export var pathfinder: GridPathfinder

var _was_night := false
var offscreen_range := 50.0

func _ready() -> void:
	var t := Timer.new()
	t.wait_time = interval
	t.timeout.connect(_on_tick)
	add_child(t)
	t.start()

func _on_tick() -> void:
	var night := GameClock.is_night()
	if night and enemies_root.get_child_count() < max_alive:
		_spawn()
	elif _was_night and not night:
		for e in enemies_root.get_children(): # deletion algorithm
			#e.queue_free()
			pass
	_was_night = night

func _spawn() -> void:
	var pos: Variant = _find_spawn_position()
	if pos == null:
		return
	var enemy: Enemy = enemy_scene.instantiate() as Enemy
	enemy.data = pool.pick_random()
	enemies_root.add_child(enemy)
	enemy.global_position = pos
	#print("enemy spawned at ", pos)

func _find_spawn_position() -> Variant:
	var center := bounds.world_rect.get_center()
	var bounds_length := bounds.world_rect.size.length()
	var ring := bounds_length / 2.0 + offscreen_range
	
	for attempt in 20:
		var pos := center + Vector2.from_angle(deg_to_rad(randf_range(45.0, 135.0))) * ring * randf_range(1.0, 1.3)
		return pos
	return null
