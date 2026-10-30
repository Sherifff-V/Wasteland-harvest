class_name Crop extends Node2D

var data: CropData
var harvests_done := 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var growth: GrowthComponent = $GrowthComponent

func setup(crop_data: CropData) -> void:
	data = crop_data
	growth.data = data
	growth.stage_changed.connect(_on_stage_changed)
	_on_stage_changed(0)

func _on_stage_changed(stage: int) -> void:
	sprite.texture = data.stage_textures[stage]

func is_mature() -> bool:
	return growth.is_mature()

## returns true if the plant stays in the ground
func harvest() -> bool:
	harvests_done += 1
	var can_regrow := data.regrows and (data.max_harvests == 0 or harvests_done < data.max_harvests)
	if can_regrow:
		growth.regrow()
	return can_regrow
