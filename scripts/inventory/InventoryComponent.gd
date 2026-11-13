class_name InventoryComponent extends Node

signal selected_changed(index: int)
signal deselect(index: int)

@onready var input: InputComponent = get_parent().get_node("InputComponent")
@onready var selection: PlotSelectComponent = get_parent().get_node("PlotSelectComponent")
@export var size := 9

var inventory: Inventory
var selected_index := -1   # hotbar selection

func _ready() -> void:
	inventory = Inventory.new(size)
	input.slot_selected.connect(on_slot_selected)
	input.mouse_scroll.connect(on_mouse_scroll)

func on_slot_selected(index: int) -> void:
	if selected_index == index:
		deselect.emit(index)
		selected_index = -1
	else:
		selected_index = clampi(index, 0, size - 1)
		selected_changed.emit(selected_index)
		
	selection.selection_clear(index)

func on_mouse_scroll(up: bool) -> void:
	if up:
		selected_index = clampi(selected_index-1, 0, size - 1)
	else:
		selected_index = clampi(selected_index+1, 0, size - 1)
		
	selected_changed.emit(selected_index)
	selection.selection_clear(selected_index)

func get_selected() -> InventorySlot:
	return inventory.slots[selected_index]
