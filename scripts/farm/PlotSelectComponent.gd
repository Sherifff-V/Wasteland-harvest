class_name PlotSelectComponent extends Node


@export var soil_layer: TileMapLayer 
@export var preview_layer: TileMapLayer

@onready var inventory: InventoryComponent = get_parent().get_node("InventoryComponent")
@onready var input: InputComponent = get_parent().get_node("InputComponent")
@onready var usedRect = soil_layer.get_used_rect()
@onready var grid_origin = usedRect.position
@onready var player: Player = get_parent()

var last_preview_pos: Vector2i = Vector2i(-9999, -9999)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input.mouse_right_click.connect(select_pos)
	input.mouse_hovering.connect(hovering_selection)
	inventory.selected_changed.connect(on_slot_changed)

func hovering_selection(tile: Vector2i) -> void:
	if tile != last_preview_pos:
		preview_layer.set_cell(last_preview_pos, -1)
		
		if soil_layer.get_cell_source_id(tile) == -1 and inventory.selected_index == 1:
			preview_layer.set_cell(tile, 0, Vector2i(0, 0))
	
	last_preview_pos = tile

func select_pos(pos: Vector2) -> void:
	var grid_pos = world_to_cell(pos);
	if soil_layer.get_cell_source_id(grid_pos) == -1 and inventory.selected_index == 1:
		soil_layer.set_cell(grid_pos, 0, Vector2i(0, 0));
		print("put a tile %v" % grid_pos)

func on_slot_changed(index: int) -> void:
	if index != 1:
		preview_layer.clear()
	
func world_to_cell(global_pos: Vector2) -> Vector2:
	var cell: Vector2i = soil_layer.local_to_map(soil_layer.to_local(global_pos));
	return Vector2(cell.x, cell.y);

func cell_to_world(cell: Vector2) -> Vector2:
	var soil_cell: Vector2i = Vector2i(int(cell.x), int(cell.y));
	return soil_layer.to_global(soil_layer.map_to_local(soil_cell));
