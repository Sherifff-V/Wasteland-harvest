class_name Player extends CharacterBody2D

@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var inventory_comp: InventoryComponent = $InventoryComponent

@export var seed: SeedItem
@export var hoe: ItemData

var current_weapon = null
var last_fire_time: float = 0.0

var pistol = null
var shotgun = null

func _ready() -> void:
	input_component.debug_checkinventorysig.connect(checkInventory)

func checkInventory() -> void: # debug only
	inventory_comp.inventory.add(seed, 5)

	if inventory_comp.inventory.count(hoe) == 0: inventory_comp.inventory.add(hoe, 1)

	inventory_comp.inventory.add_to_slot(seed, 1, 5)
	inventory_comp.selected_changed.connect(_on_slot_changed)

	var PistolScript = preload("res://scripts/Weapons/Pistol.gd")
	var ShotgunScript = preload("res://scripts/Weapons/Shotgun.gd")

	pistol = PistolScript.new()
	shotgun = ShotgunScript.new()

	input_component.weapon_1_selected.connect(_on_weapon_1_selected)
	input_component.weapon_2_selected.connect(_on_weapon_2_selected)

func checkInventory() -> void:
	var selected_item = inventory_comp.get_selected().item
	if selected_item:
		print("selected item name: ", selected_item.display_name,
			  ", amount: ", inventory_comp.inventory.count(selected_item))

func _physics_process(delta: float) -> void:
	movement_component.move(self, input_component.move_direction, delta)
	
	if input_component.is_shooting() and current_weapon != null:
		var current_time = Time.get_ticks_msec() / 1000.0
		if current_time - last_fire_time >= current_weapon.fire_rate:
			current_weapon.shoot(self, get_global_mouse_position())
			last_fire_time = current_time

func _on_weapon_1_selected() -> void:
	current_weapon = pistol
	print("Выбрано: ", pistol.display_name)

func _on_weapon_2_selected() -> void:
	current_weapon = shotgun
	print("Выбрано: ", shotgun.display_name)

func _on_slot_changed(_index: int) -> void:
	var selected_slot = inventory_comp.get_selected()
	if selected_slot.is_empty():
		current_weapon = null
