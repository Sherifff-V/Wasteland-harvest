class_name Shotgun
extends Weapon

func _init() -> void:
	super._init(
		"Дробовик",
		15,      # damage
		0.8,     # fire_rate
		300.0,   # range
		700.0,   # bullet_speed
		5,       # bullets_per_shot
		0.15     # spread_angle (разброс)
	)
