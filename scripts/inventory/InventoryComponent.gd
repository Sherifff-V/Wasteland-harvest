class_name InventoryComponent extends Node

signal selected_changed(index: int)

@onready var input: InputComponent = get_parent().get_node("InputComponent")
@export var size := 2

var inventory: Inventory
var selected_index := 0   # hotbar selection

func _ready() -> void:
	inventory = Inventory.new(size)
	input.slot_selected.connect(on_slot_selected)

func on_slot_selected(index: int) -> void:
	selected_index = clampi(index, 0, size - 1)
	print("selected slot %d" %selected_index)
	selected_changed.emit(selected_index)

func get_selected() -> InventorySlot:
	return inventory.slots[selected_index]
