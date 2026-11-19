class_name Shotgun

var display_name: String = "Дробовик"
var damage: int = 15
var fire_rate: float = 0.8
var range: float = 300.0
var bullet_speed: float = 700.0
var bullets_per_shot: int = 5
var spread_angle: float = 0.15 

func shoot(shooter: Node2D, target_pos: Vector2) -> void:
	var direction = (target_pos - shooter.global_position).normalized()
	var base_angle = direction.angle()
	
	for i in bullets_per_shot:
		var angle_offset = 0.0
		if bullets_per_shot > 1:
			angle_offset = (i - (bullets_per_shot - 1) / 2.0) * spread_angle
		
		var bullet_direction = Vector2.from_angle(base_angle + angle_offset)
		_spawn_bullet(shooter, bullet_direction)

func _spawn_bullet(shooter: Node2D, direction: Vector2) -> void:
	var bullet_scene = preload("res://scenes/Bullet.tscn")
	var bullet: Node2D = bullet_scene.instantiate()
	
	bullet.global_position = shooter.global_position
	bullet.direction = direction
	bullet.speed = bullet_speed
	bullet.damage = damage
	bullet.range = range
	
	shooter.get_tree().current_scene.add_child(bullet)
