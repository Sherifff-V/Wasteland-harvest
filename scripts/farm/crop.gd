class_name Crop extends Node2D

signal destroyed

var data: CropData
var harvests_done := 0
var cell: Vector2i
var health := 1

@onready var sprite: Sprite2D = $Sprite2D
@onready var growth: GrowthComponent = $GrowthComponent
@onready var base: Sprite2D = $Base

func setup(crop_data: CropData) -> void:
	data = crop_data
	growth.data = data
	health = data.max_health
	growth.stage_changed.connect(_on_stage_changed)
	_on_stage_changed(0)

func _on_stage_changed(stage: int) -> void:
	var tex := data.stage_textures[stage]
	var w := tex.get_width()
	var h := tex.get_height()
	var off := Vector2(-w / 2.0, -h / 2.0)

	base.texture = tex
	base.centered = false
	base.offset = off

	sprite.texture = tex
	sprite.centered = false
	sprite.offset = off
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0, 0, w, h - 18) # might change h - 18 to sometihng else

func is_mature() -> bool:
	return growth.is_mature()

func take_damage(amount: int) -> void:
	if health <= 0:
		return
	health -= amount
	base.modulate = Color(1, 0.4, 0.4)
	sprite.modulate = Color(1, 0.4, 0.4)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(base, "modulate", Color.WHITE, 0.15)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.15)
	if health <= 0:
		tween.finished.connect(destroyed.emit)

## returns true if the plant stays in the ground
func harvest() -> bool:
	harvests_done += 1
	var can_regrow := data.regrows and (data.max_harvests == 0 or harvests_done < data.max_harvests)
	if can_regrow:
		growth.regrow()
	return can_regrow
