class_name InventorySlot_UI extends TextureRect

@onready var icon: TextureRect = $Icon
@onready var label: Label = $Label 
@onready var count: Label = $Count

@export var normal_texture: Texture2D
@export var selected_texture: Texture2D

var inv_comp: InventoryComponent

func _ready() -> void:
	inv_comp = get_tree().get_first_node_in_group("player_inventory")
	
	if inv_comp:
		inv_comp.selected_changed.connect(on_selected_changed)
		inv_comp.inventory.slot_changed.connect(set_item)
		print("set item in _ready")

func set_item(index: int) -> void:
	if name != "Slot" + str(index + 1):
		return
		
	var slot: InventorySlot = inv_comp.inventory.slots[index]
	var item: ItemData = slot.item
	
	if item != null:
		if item.icon != null:
			icon.texture = item.icon
		else:
			label.text = item.display_name
			
		count.text = str(slot.amount) + 'X'
	else:
		clear_slot()

func on_selected_changed(index: int) -> void:
	if name == "Slot" + str(index + 1):
		texture = selected_texture
		custom_minimum_size = Vector2(18*4, 18*4)
		icon.size = Vector2(18*4, 18*4)
	else:
		texture = normal_texture
		custom_minimum_size = Vector2(16*4, 16*4)
		icon.size = Vector2(16*4, 16*4)

func clear_slot() -> void:
	label.text = ""
	count.text = ""
	icon.texture = null
	icon.visible = false
