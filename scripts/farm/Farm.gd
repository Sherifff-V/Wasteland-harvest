class_name Farm extends Node

@export var soil: TileMapLayer
@export var ground: TileMapLayer
@export var crops_root: Node2D
@export var crop_scene: PackedScene
@export var player: Player

var crops: Dictionary = {}   # Vector2i -> Crop

const NO_CELL := Vector2i(999999, 999999)
const TERRAIN_SET = 0
const GRASS_TERRAIN = 0

func has_crop(cell: Vector2i) -> bool:
	return crops.has(cell)
	
# returns true if successful
func dig_dirt(cell: Vector2i) -> bool:
	var cells_to_dig: Array[Vector2i] = []

	cells_to_dig.append(cell)

	if cells_to_dig.is_empty():
		return false

	soil.set_cell(cell, 1, Vector2i(0, 0))

	for offset in [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                  Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
	]:
		var neighbor_cell = cell + offset
		if soil.get_cell_source_id(neighbor_cell) == -1:
			soil.set_cell(neighbor_cell, 2, Vector2i(0, 0))

	# 3. Erase the 3x3 grass cells AND automatically update all surrounding terrain borders
	# Passing -1 as the terrain ID erases the cells and recalculates neighbors properly
	ground.set_cells_terrain_connect(cells_to_dig, TERRAIN_SET, -1, false)

	return true

func check_player_collision(cell: Vector2i) -> bool:
	#player rect
	var col_shape: CollisionShape2D = player.get_node("CollisionShape2D")
	var hitbox_size: Vector2 = col_shape.shape.get_rect().size
	var player_rect: Rect2 = Rect2(col_shape.global_position - (hitbox_size * 0.5), hitbox_size)
	
	#cell rect
	var tile_size: Vector2 = Vector2(soil.tile_set.tile_size)
	var cell_local_pos: Vector2 = soil.map_to_local(cell) - (tile_size * 0.5)
	var cell_rect: Rect2 = Rect2(soil.to_global(cell_local_pos), tile_size)
	
	return not cell_rect.intersects(player_rect)

func can_plant(cell: Vector2i) -> bool:
	return soil.get_cell_source_id(cell) == 1 and not crops.has(cell) and check_player_collision(cell)

func plant(cell: Vector2i, crop_data: CropData) -> bool:
	if not can_plant(cell):
		return false
	var crop: Crop = crop_scene.instantiate() as Crop
	crops_root.add_child(crop)
	crop.global_position = soil.to_global(soil.map_to_local(cell)) + crop_data.offset
	crop.z_index = 2;
	crop.setup(crop_data)
	crops[cell] = crop
	return true

## returns the crop's data if it can be harvested right now, otherwise null
func get_harvestable(cell: Vector2i) -> CropData:
	var crop: Crop = crops.get(cell)
	if crop and crop.is_mature():
		return crop.data
	return null

func harvest(cell: Vector2i) -> void:
	var crop: Crop = crops.get(cell)
	if crop == null:
		return
	if not crop.harvest(): # one-time crop or out of harvests
		crop.queue_free()
		crops.erase(cell)
		
func nearest_harvestable(center: Vector2i, radius: float) -> Vector2i:
	var best := NO_CELL
	var best_dist := INF
	
	for cell in crops:
		if not crops[cell].is_mature():
			continue
			
		var d := Vector2(cell).distance_to(Vector2(center))
		
		if d <= radius and d < best_dist:
			best = cell
			
		best_dist = d
	return best
