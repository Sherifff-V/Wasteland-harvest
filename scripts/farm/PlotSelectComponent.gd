class_name PlotSelectComponent extends Node

signal cell_selected(cell: Vector2i)

@export var soil_layer: TileMapLayer 
@export var preview_layer: TileMapLayer
@export var selection_range = 5;
@export var farm: Farm

@onready var inventory_comp: InventoryComponent = get_parent().get_node("InventoryComponent")
@onready var input: InputComponent = get_parent().get_node("InputComponent")
@onready var usedRect = soil_layer.get_used_rect()
@onready var grid_origin = usedRect.position
@onready var player: Player = get_parent()

var last_preview_pos: Vector2i = Vector2i(-9999, -9999)
var selected_cell: Vector2i

func _ready() -> void:
	input.left_click_pressed.connect(select_pos)
	input.interact_pressed.connect(select_nearest)
	input.mouse_hovering.connect(hovering_selection)
	inventory_comp.selected_changed.connect(selection_clear)

func hovering_selection(tile: Vector2i) -> void:
	if tile != last_preview_pos:
		preview_layer.set_cell(last_preview_pos, -1)
		
		var item = inventory_comp.get_selected().item
		update_selection(tile, item)
	
	last_preview_pos = tile

func select_pos(pos: Vector2) -> void:
	var grid_pos = world_to_cell(pos);
	var item = inventory_comp.get_selected().item
	
	if item != null and in_placeable_distance(grid_pos):
		selected_cell = grid_pos
		cell_selected.emit(grid_pos, item)
		update_selection(grid_pos, item)

func select_nearest() -> void:
	var center := world_to_cell(get_parent().global_position)
	var cell := farm.nearest_harvestable(center, selection_range)
	
	if cell != Farm.NO_CELL:
		selected_cell = cell
		cell_selected.emit(cell, null)

func in_placeable_distance(tile_pos: Vector2i) -> bool:
	var player_pos = get_parent().global_position
	return tile_pos.distance_to(world_to_cell(player_pos)) <= selection_range

func selection_clear(index: int) -> void:
	preview_layer.clear()
	update_selection(last_preview_pos, inventory_comp.get_selected().item)
	
	last_preview_pos = Vector2i(-9999, -9999)
	
func update_selection(tile: Vector2i, item: ItemData) -> void:
	if item != null and in_placeable_distance(tile):
		if item.id == "hoe":
			if not farm.can_dig(tile):
				preview_layer.set_cell(tile, 0, Vector2i(0, 0))
			else:
				preview_layer.set_cell(tile, 1, Vector2i(0, 0))
		elif item.id == "cucumber_seed":
			if !farm.can_plant(tile):
				preview_layer.set_cell(tile, 0, Vector2i(0, 0))
			else:
				preview_layer.set_cell(tile, 1, Vector2i(0, 0))
	
func world_to_cell(global_pos: Vector2) -> Vector2:
	var cell: Vector2i = soil_layer.local_to_map(soil_layer.to_local(global_pos));
	return Vector2(cell.x, cell.y);

func cell_to_world(cell: Vector2) -> Vector2:
	var soil_cell: Vector2i = Vector2i(int(cell.x), int(cell.y));
	return soil_layer.to_global(soil_layer.map_to_local(soil_cell));
