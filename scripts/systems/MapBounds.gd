class_name MapBounds extends Node

@export var ground: TileMapLayer
@export var explicit_origin := Vector2i.ZERO
@export var explicit_size := Vector2i(100, 100)

var cell_rect: Rect2i # the map in cells
var world_rect: Rect2 # the map in pixels

func _ready() -> void:
	add_to_group("map_bounds")
	refresh()
	_apply_camera_limits()

func refresh() -> void:
	cell_rect = Rect2i(explicit_origin, explicit_size)
	var ts := Vector2(ground.tile_set.tile_size)
	var top_left := ground.to_global(ground.map_to_local(cell_rect.position)) - ts / 2.0
	world_rect = Rect2(top_left, Vector2(cell_rect.size) * ts)

func contains_world(pos: Vector2) -> bool:
	return world_rect.has_point(pos)

func clamp_world(pos: Vector2) -> Vector2:
	return pos.clamp(world_rect.position, world_rect.end)

func _apply_camera_limits() -> void:
	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return
	cam.limit_left = int(world_rect.position.x)
	cam.limit_top = int(world_rect.position.y)
	cam.limit_right = int(world_rect.end.x)
	cam.limit_bottom = int(world_rect.end.y)
