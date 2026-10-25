class_name MovementComponent
extends Node
 
@export var speed: float = 180.0
@export var acceleration: float = 1200.0
@export var friction: float = 800.0
 
var _time_since_start: float = 0.5
 
 
func move(body: CharacterBody2D, direction: Vector2, delta: float) -> void:
	var rate := friction if direction == Vector2.ZERO else acceleration
	var step := rate * delta
 
	if direction == Vector2.ZERO:
		_time_since_start = 0.5
	else:
		_time_since_start = minf(_time_since_start + delta, 1.0)
		step *= _time_since_start * _time_since_start
 
	var target := direction * speed
	body.velocity = body.velocity.move_toward(target, step)
	body.move_and_slide()
