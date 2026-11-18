class_name Player extends CharacterBody2D

@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var inventory_comp: InventoryComponent = $InventoryComponent

#хп
@onready var hp_label: Label = get_tree().current_scene.get_node("UI/HealthLabel")

@export var seed: SeedItem
@export var hoe: ItemData
@export var maxhp := 100
var hp:= 100
var isDead := false	

func _ready() -> void:
	input_component.debug_checkinventorysig.connect(checkInventory)
	
	#хп
	hp = maxhp
	update_hp_lab()
	takedmg(100)
 
func checkInventory() -> void: # debug only
	inventory_comp.inventory.add(seed, 5)
	
	if inventory_comp.inventory.count(hoe) == 0: inventory_comp.inventory.add(hoe, 1)
		
	var selected_item = inventory_comp.get_selected().item
	if selected_item:
		print("selected item name: ", selected_item.display_name, ", amount: ", inventory_comp.inventory.count(selected_item))
	
#ф-ия обновления плашки хп
func update_hp_lab() -> void:
	hp_label.text = "HP: %d/%d" % [hp, maxhp]

#ф-ия получения урона
func takedmg(amount : int) -> void:
	if amount <= 0 or isDead: 
		return
	hp = maxi(hp - amount, 0) #защита от отрицательного здоровья
	update_hp_lab()
	print("HP: ", hp, "/", maxhp)
	
	if hp == 0:
		isDead = true
		print('МЁРТВ!!!1!😭')
	
	
#ф-ия хила
func heal(amount:int) -> void:
	if amount <= 0 or isDead:
		return
	hp = mini(hp + amount, maxhp)
	update_hp_lab()
	print("HP: ", hp, "/", maxhp)
	


func _physics_process(delta: float) -> void:
	movement_component.move(self, input_component.move_direction, delta)
	
