class_name HealthSystem extends Node
signal hp_changed(current_hp: int)
signal died

@export var maxhp := 100
@export var sprite: Sprite2D

var hp:= 100
var isDead := false	

func _ready() -> void:
	hp = maxhp

func setup(new_maxhp: int) -> void:
	maxhp = maxi(new_maxhp, 1)
	hp = maxhp
	isDead = false
	hp_changed.emit(hp)

#ф-ия хила
func heal(amount:int) -> void:
	if amount <= 0 or isDead:
		return
	hp = mini(hp + amount, maxhp)
	hp_changed.emit(hp)
	#print("HP: ", hp, "/", maxhp)
	
	
#ф-ия получения урона
func take_damage(amount : int) -> void:
	if amount <= 0 or isDead: 
		return
	hp = maxi(hp - amount, 0)
	
	if hp == 0:
		isDead = true

	hp_changed.emit(hp)
	sprite.modulate = Color(1, 0.4, 0.4)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.15)

	if isDead:
		tween.finished.connect(died.emit)
		

	print("HP: ", hp, "/", maxhp)
