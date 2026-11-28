class_name Bullet
extends Area2D

const SPEED := 700.0
const LIFETIME := 2.0

var velocity := Vector2.ZERO
var damage := 1
var _shooter: Node = null
var _life := LIFETIME

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	queue_redraw() 


func setup(pos: Vector2, dir: Vector2, dmg: int, shooter: Node) -> void:
	global_position = pos
	velocity = dir.normalized() * SPEED
	damage = dmg
	_shooter = shooter
	_life = LIFETIME

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	_life -= delta
	if _life <= 0.0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	_hit(body)

func _on_area_entered(area: Area2D) -> void:
	_hit(area)

func _hit(target: Node) -> void:
	if target == _shooter or target.is_in_group("player"):# or target.is_in_group("crop"):
		return
	if target.has_method("take_damage"):
		target.take_damage(damage)
	elif target.has_method("on_bullet_hit"):
		target.on_bullet_hit(damage)
	queue_free()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 8.0, Color.YELLOW)
