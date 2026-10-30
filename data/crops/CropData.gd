class_name CropData extends Resource

@export var id: StringName
@export var days_per_stage: int = 1
@export var stage_textures: Array[Texture2D]

@export_group("Harvest")
@export var harvest_item: ItemData
@export var harvest_amount: int = 1

@export_group("Regrowing")
@export var regrows := false
@export var regrow_stage: int = 1 # stage the plant goes back to after harvest
@export var max_harvests: int = 0 # 0 = unlimited
