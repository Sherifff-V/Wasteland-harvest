class_name Bullet
extends Area2D

var direction: Vector2
var speed: float = 800.0
var damage: int = 10
var range: float = 500.0
var distance_traveled: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, Color.YELLOW)

func _physics_process(delta: float) -> void:
	var movement = direction * speed * delta
	position += movement
	distance_traveled += movement.length()
	
	if distance_traveled >= range:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		return
	
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	queue_free()
