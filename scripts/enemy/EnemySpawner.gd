class_name EnemySpawner extends Node

@export var enemy_scene: PackedScene
@export var pool: Array[EnemyData]
@export var enemies_root: Node2D
@export var player: Node2D
@export var max_alive := 6
@export var spawn_distance := 350.0
@export var interval := 4.0

var _was_night := false

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
		for e in enemies_root.get_children(): #deletion algorithm
			#e.queue_free()
			pass
	_was_night = night

func _spawn() -> void:
	var enemy: Enemy = enemy_scene.instantiate() as Enemy
	enemy.data = pool.pick_random()
	enemies_root.add_child(enemy)
	var angle := randf() * TAU
	enemy.global_position = player.global_position + Vector2.from_angle(angle) * spawn_distance
