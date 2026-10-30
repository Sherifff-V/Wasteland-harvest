class_name Player extends CharacterBody2D

@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var inventory_comp: InventoryComponent = $InventoryComponent

@export var seed: SeedItem

func _ready() -> void:
	input_component.debug_checkinventorysig.connect(checkInventory)
	inventory_comp.inventory.add_to_slot(seed, 1, 5)
 
func checkInventory() -> void: # debug only
	var selected_item_name = inventory_comp.get_selected().item.display_name
	print("selected item name: ", selected_item_name)
	

func _physics_process(delta: float) -> void:
	movement_component.move(self, input_component.move_direction, delta)
	
