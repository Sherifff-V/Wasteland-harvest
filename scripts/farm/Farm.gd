class_name Farm extends Node

@export var soil: TileMapLayer
@export var crops_root: Node2D
@export var crop_scene: PackedScene

var crops: Dictionary = {}   # Vector2i -> Crop
const NO_CELL := Vector2i(999999, 999999)

func has_crop(cell: Vector2i) -> bool:
	return crops.has(cell)

func can_plant(cell: Vector2i) -> bool:
	return soil.get_cell_atlas_coords(cell) == Vector2i(1,0) and not crops.has(cell)

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
