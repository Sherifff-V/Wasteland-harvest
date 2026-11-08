class_name PlantComponent extends Node

@export var input: InputComponent
@export var selector: PlotSelectComponent
@export var farm: Farm
@export var inventory_comp: InventoryComponent

func _ready() -> void:
	selector.cell_selected.connect(interact)

func interact(cell: Vector2i) -> void:
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
		var item := inventory_comp.get_selected().item # add check for seed item later
		if item != null and item.id == "cucumber_seed" and farm.plant(cell, item.crop):
			inventory_comp.inventory.remove(item, 1)
