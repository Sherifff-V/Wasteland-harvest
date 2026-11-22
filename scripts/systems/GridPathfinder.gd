class_name GridPathfinder extends Node

@export var ground: TileMapLayer
@export var obstacle_layers: Array[TileMapLayer]
@export var obstacle_key: String = "isObstacle"

var astar := AStarGrid2D.new()
var _extra_blocked := {}   # Vector2i -> true

func _ready() -> void:
	add_to_group("pathfinder")
	rebuild()

func rebuild() -> void:
	var rect := Rect2i()
	var layers: Array = [ground] + obstacle_layers
	for layer in layers:
		var r: Rect2i = layer.get_used_rect()
		if not r.has_area():
			continue
		rect = r if not rect.has_area() else rect.merge(r)

	astar.region = rect
	astar.cell_size = Vector2.ONE
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.update()

	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			refresh_cell(Vector2i(x, y))

func refresh_cell(cell: Vector2i) -> void:
	if astar.is_in_boundsv(cell):
		astar.set_point_solid(cell, _tile_is_obstacle(cell) or _extra_blocked.has(cell))

## obstacles that are scene nodes (trees, rocks, fences)
func set_blocked(cell: Vector2i, blocked: bool) -> void:
	if blocked:
		_extra_blocked[cell] = true
	else:
		_extra_blocked.erase(cell)
	refresh_cell(cell)

func _tile_is_obstacle(cell: Vector2i) -> bool:
	for layer in obstacle_layers:
		if layer.tile_set == null or not layer.tile_set.has_custom_data_layer_by_name(obstacle_key):
			continue
		var data := layer.get_cell_tile_data(cell)
		if data and data.get_custom_data(obstacle_key):
			return true
	return false

func world_to_cell(pos: Vector2) -> Vector2i:
	return ground.local_to_map(ground.to_local(pos))

func cell_to_world(cell: Vector2i) -> Vector2:
	return ground.to_global(ground.map_to_local(cell))

func is_walkable(pos: Vector2) -> bool:
	var cell := world_to_cell(pos)
	return astar.is_in_boundsv(cell) and not astar.is_point_solid(cell)

## returns world positions (cell centers); empty if there is no path
func find_path(from_world: Vector2, to_world: Vector2) -> PackedVector2Array:
	var out := PackedVector2Array()
	var a := world_to_cell(from_world)
	var b := world_to_cell(to_world)
	if not astar.is_in_boundsv(a) or not astar.is_in_boundsv(b):
		return out
	if astar.is_point_solid(a) or astar.is_point_solid(b):
		return out
	for cell in astar.get_id_path(a, b):
		out.append(cell_to_world(cell))
	return out
	
func _ids_to_world(ids: Array[Vector2i]) -> PackedVector2Array:
	var out := PackedVector2Array()
	for cell in ids:
		out.append(cell_to_world(cell))
	return out

func find_path_near(from_world: Vector2, to_world: Vector2) -> PackedVector2Array:
	var direct := find_path(from_world, to_world)
	if not direct.is_empty():
		return direct
	var a := world_to_cell(from_world)
	var b := world_to_cell(to_world)
	if not astar.is_in_boundsv(a) or astar.is_point_solid(a):
		return PackedVector2Array()
	var best: Array[Vector2i] = []
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			if dx == 0 and dy == 0:
				continue
			var n := b + Vector2i(dx, dy)
			if not astar.is_in_boundsv(n) or astar.is_point_solid(n):
				continue
			var ids := astar.get_id_path(a, n)
			if not ids.is_empty() and (best.is_empty() or ids.size() < best.size()):
				best = ids
	return _ids_to_world(best)
