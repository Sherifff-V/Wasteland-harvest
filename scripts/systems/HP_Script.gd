class_name HealthSystem extends Node

signal died;

@onready var hp_label: Label = get_tree().current_scene.get_node("UI/HealthContainer/HealthLabel")
var hp:= 1
var maxhp := 1
var isDead := false	

func _ready() -> void:
	update_hp_lab()

func setup(given_maxhp: int) -> void:
	maxhp = given_maxhp
	hp = maxhp

#ф-ия обновления плашки хп
func update_hp_lab() -> void:
	hp_label.text = "HP: %d/%d" % [hp, maxhp]

#ф-ия хила
func heal(amount:int) -> void:
	if amount <= 0 or isDead:
		return
	hp = mini(hp + amount, maxhp)
	update_hp_lab()
	print("HP: ", hp, "/", maxhp)
	
	
#ф-ия получения урона
func take_damage(amount : int) -> void:
	if amount <= 0 or isDead: 
		return
	hp = maxi(hp - amount, 0) #защита от отрицательного здоровья
	update_hp_lab()
	print("HP: ", hp, "/", maxhp)
	
	if hp == 0:
		isDead = true
		died.emit()
		print('ТЫ МЁРТВ!!!1!😭')
