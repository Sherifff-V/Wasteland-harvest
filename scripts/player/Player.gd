class_name Player extends CharacterBody2D

@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var inventory_comp: InventoryComponent = $InventoryComponent



@export var seed: SeedItem
@export var hoe: ItemData

#хп
@onready var hp_label: Label = get_tree().current_scene.get_node("UI/HealthContainer/HealthLabel")
@onready var hp_sys = $HealthSystem

func _ready() -> void:
	input_component.debug_checkinventorysig.connect(checkInventory)
	
	#хп
	hp_sys.hp_changed.connect(update_hp_lab)
	update_hp_lab(hp_sys.hp, hp_sys.maxhp)
	
	
func checkInventory() -> void: # debug only
	inventory_comp.inventory.add(seed, 5)
	
	if inventory_comp.inventory.count(hoe) == 0: inventory_comp.inventory.add(hoe, 1)
		
	var selected_item = inventory_comp.get_selected().item
	if selected_item:
		print("selected item name: ", selected_item.display_name, ", amount: ", inventory_comp.inventory.count(selected_item))
	

	
	
#ф-ия обновления плашки хп
func update_hp_lab(hp  : int, maxhp : int) -> void:
	hp_label.text = "HP: %d/%d" % [hp, maxhp]

func _physics_process(delta: float) -> void:
	if hp_sys.isDead: #прекращение движения при смерти
		velocity = Vector2.ZERO
		return
	movement_component.move(self, input_component.move_direction, delta)
