class_name PlotSelectComponent extends Node


@export var soil_layer: TileMapLayer 
@onready var usedRect = soil_layer.get_used_rect()
@onready var grid_origin = usedRect.position
@onready var player: Player = get_parent();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.mouse_pos.connect(selectPos);

func selectPos(pos: Vector2) -> void:
	var grid_pos = world_to_cell(pos);
	if soil_layer.get_cell_source_id(grid_pos) == -1:
		soil_layer.set_cell(grid_pos, 0, Vector2i(0, 0));
		print("put a tile %v" % grid_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func world_to_cell(global_pos: Vector2) -> Vector2:
	var cell: Vector2i = soil_layer.local_to_map(soil_layer.to_local(global_pos));
	return Vector2(cell.x, cell.y);

func cell_to_world(cell: Vector2) -> Vector2:
	var soil_cell: Vector2i = Vector2i(int(cell.x), int(cell.y));
	return soil_layer.to_global(soil_layer.map_to_local(soil_cell));
