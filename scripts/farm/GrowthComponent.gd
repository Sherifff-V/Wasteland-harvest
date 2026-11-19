class_name GrowthComponent extends Node

signal stage_changed(stage: int)

var data: CropData
var growth_time := 0.0
var stage := 0

var full_growth_time := 0.0

func _ready() -> void:
	if data != null:
		full_growth_time = data.stage_textures.size() * data.stage_growth_time

func _process(delta: float) -> void:
	if GameClock.is_day():
		growth_time += delta
		_update_stage()

func _update_stage() -> void:
	var last := data.stage_textures.size() - 1

	var new_stage := mini(int(growth_time / data.stage_growth_time), last)

	if new_stage != stage:
		stage = new_stage
		stage_changed.emit(stage)

func is_mature() -> bool:
	return stage >= data.stage_textures.size() - 1

func regrow() -> void:
	stage = data.regrow_stage
	growth_time = stage * data.stage_growth_time
	stage_changed.emit(stage)
