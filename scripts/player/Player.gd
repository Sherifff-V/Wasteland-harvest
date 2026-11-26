class_name Player extends CharacterBody2D

@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var inventory_comp: InventoryComponent = $InventoryComponent
@onready var ui_comp: UIComponent = $UIComponent
@onready var shooting: ShootingComponent = $ShootingComponent

@export var seed: SeedItem
@export var hoe: ItemData

#хп
@onready var hp_sys = $HealthSystem

func _ready() -> void:
	input_component.debug_checkinventorysig.connect(checkInventory)
	_give_starting_loadout()
	#хп
	hp_sys.hp_changed.connect(_on_hp_changed)
	ui_comp.update_hp_lab(hp_sys.hp, hp_sys.maxhp)
	
	
func checkInventory() -> void: # debug only
	inventory_comp.inventory.add(seed, 5)
	
	if inventory_comp.inventory.count(hoe) == 0: inventory_comp.inventory.add(hoe, 1)
		
	var selected_item = inventory_comp.get_selected().item
	if selected_item:
		print("selected item name: ", selected_item.display_name, ", amount: ", inventory_comp.inventory.count(selected_item))
	

func take_damage(amount: int) -> void:
	hp_sys.take_damage(amount)

func _on_hp_changed(new_hp: int) -> void:
	ui_comp.update_hp_lab(new_hp, hp_sys.maxhp)

func collect(item_id: StringName, amount: int) -> int:
	var item: ItemData = ItemDatabase.create_item(item_id)
	var left := inventory_comp.inventory.add(item, amount)
	var got := amount - left
	if got > 0:
		Messages.post("+%d %s" % [got, item.display_name])
	if left > 0:
		Messages.post("Inventory full", Color.ORANGE_RED, 2.0)
	return left

func _physics_process(delta: float) -> void:
	if hp_sys.isDead: #прекращение движения при смерти
		velocity = Vector2.ZERO
		return
	movement_component.move(self, input_component.move_direction, delta)
	
func _give_starting_loadout() -> void:
	var inv := inventory_comp.inventory
	var pistol := ItemDatabase.create_item(&"pistol")
	var ammo := ItemDatabase.create_item(&"ammo_pistol")

	if pistol == null:
		print("ОШИБКА: pistol.tres не загружен! Проверь id в файле.")
		return
	if ammo == null:
		print("ОШИБКА: ammo_pistol.tres не загружен!")
		return
	
	inv.add_to_slot(pistol, 6, 1)
	inv.add_to_slot(ammo, 7, 30)
