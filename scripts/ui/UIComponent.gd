class_name UIComponent extends Node

signal harvestable_nearby_changed(is_near: bool)

@export var farm: Farm
@export var selector: PlotSelectComponent
@export var inv_comp: InventoryComponent

@onready var player: Node2D = get_parent()
@onready var hp_label: Label = get_tree().current_scene.get_node("UI/HealthContainer/HealthLabel")

var _was_near := false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	#harvest hint
	var center := selector.world_to_cell(player.global_position)
	var near := farm.nearest_harvestable(center, selector.selection_range) != farm.NO_CELL
	if near != _was_near:
		_was_near = near
		harvestable_nearby_changed.emit(near)
		
#ф-ия обновления плашки хп
func update_hp_lab(hp  : int, maxhp : int) -> void:
	hp_label.text = "HP: %d/%d" % [hp, maxhp]
