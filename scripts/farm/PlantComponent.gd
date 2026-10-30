class_name PlantComponent extends Node

@export var input: InputComponent
@export var selector: PlotSelectComponent
@export var farm: Farm
@export var inventory_comp: InventoryComponent

func _ready() -> void:
	#input.interact_pressed.connect(interact)
	pass

func interact() -> void:
	var cell := selector.selected_cell
	var inv := inventory_comp.inventory
	
	if cell == null:
		push_warning("Planted selection cell has not been selected")
		return

	if farm.has_crop(cell):
		var crop := farm.get_harvestable(cell)
		if crop and inv.can_add(crop.harvest_item, crop.harvest_amount):
			farm.harvest(cell)
			inv.add(crop.harvest_item, crop.harvest_amount)
	else:
		var item := inventory_comp.get_selected().item
		if item is SeedItem and farm.plant(cell, item.crop):
			inv.remove(item, 1)
