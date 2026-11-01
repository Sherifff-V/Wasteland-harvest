class_name UIComponent extends Node

signal harvestable_nearby_changed(is_near: bool)

@export var farm: Farm
@export var selector: PlotSelectComponent

@onready var player: Node2D = get_parent()
var _was_near := false

func _process(_delta: float) -> void:
	var center := selector.world_to_cell(player.global_position)
	var near := farm.nearest_harvestable(center, selector.selection_range) != farm.NO_CELL
	if near != _was_near:
		_was_near = near
		harvestable_nearby_changed.emit(near)
