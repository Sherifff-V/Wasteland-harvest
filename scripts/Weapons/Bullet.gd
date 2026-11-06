extends Area2D

var direction: Vector2
var speed: float
var damage: int
var range: float
var distance_traveled: float = 0.0

func _physics_process(delta: float) -> void:
	var movement = direction * speed * delta
	position += movement
	distance_traveled += movement.length()
	
	if distance_traveled >= range:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	print("Пуля столкнулась с: ", body.name)
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
