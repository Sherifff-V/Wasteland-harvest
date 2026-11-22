class_name EnemyDamageComponent extends Node

@export var attack_interval := 1.0
var damage := 1

var _cooldown := 0.0

func _process(delta: float) -> void:
	_cooldown = maxf(_cooldown - delta, 0.0)

func try_attack(target: Node) -> bool:
	if _cooldown > 0.0 or not is_instance_valid(target) or not target.has_method("take_damage"):
		return false
	target.take_damage(damage)
	_cooldown = attack_interval
	return true
