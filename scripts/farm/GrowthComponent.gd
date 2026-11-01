class_name GrowthComponent extends Node

signal stage_changed(stage: int)

var data: CropData
var days := 0
var stage := 0

func _ready() -> void:
	GameClock.day_passed.connect(_on_day_passed)

func _on_day_passed(_day: int) -> void:
	days += 1
	_update_stage()

func _update_stage() -> void:
	var last := data.stage_textures.size() - 1
	var new_stage := mini(days / data.days_per_stage, last)
	if new_stage != stage:
		stage = new_stage
		stage_changed.emit(stage)

func is_mature() -> bool:
	return stage >= data.stage_textures.size() - 1

func regrow() -> void:
	stage = data.regrow_stage
	days = stage * data.days_per_stage
	stage_changed.emit(stage)
