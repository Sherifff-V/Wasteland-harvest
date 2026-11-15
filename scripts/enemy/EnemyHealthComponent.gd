class_name EnemyHealthComponent extends Node

signal health_changed(current: int, maximum: int)
signal died

var max_health := 1
var current := 1

func setup(max_hp: int) -> void:
	max_health = max_hp
	current = max_hp
	health_changed.emit(current, max_health)

func take_damage(amount: int) -> void:
	if current <= 0:
		return
		
	current = maxi(current - amount, 0)
	health_changed.emit(current, max_health)
	
	if current == 0:
		died.emit()
