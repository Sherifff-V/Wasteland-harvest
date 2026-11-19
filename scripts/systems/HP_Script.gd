class_name HealthSystem extends Node
@onready var hp_label: Label = get_tree().current_scene.get_node("UI/HealthContainer/HealthLabel")
@export var maxhp := 100
var hp:= 100
var isDead := false	

func _ready() -> void:
	hp = maxhp
	update_hp_lab()

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
func takedmg(amount : int) -> void:
	if amount <= 0 or isDead: 
		return
	hp = maxi(hp - amount, 0) #защита от отрицательного здоровья
	update_hp_lab()
	print("HP: ", hp, "/", maxhp)
	
	if hp == 0:
		isDead = true
		print('ТЫ МЁРТВ!!!1!😭')
