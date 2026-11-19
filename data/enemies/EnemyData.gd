class_name EnemyData extends Resource

@export var id: StringName
@export var display_name: String
@export var texture: Texture2D
@export var max_health: int = 3
@export var speed: float = 40.0
@export var detection_range: float = 200.0
@export var attack_reach: float = 22.0
@export var damage: int = 1
@export var attack_interval: float = 3.0
@export var drops: Array[ItemData]
