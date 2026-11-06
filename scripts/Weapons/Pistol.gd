class_name Pistol
extends Weapon

func _init() -> void:
	super._init(
		"Пистолет",
		25,      # damage
		0.3,     # fire_rate (секунды между выстрелами)
		500.0,   # range
		800.0,   # bullet_speed
		1,       # bullets_per_shot
		0.0      # spread_angle (без разброса)
	)
