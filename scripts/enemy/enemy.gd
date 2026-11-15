class_name Enemy extends CharacterBody2D

@export var data: EnemyData
@onready var health: EnemyHealthComponent = $HealthComponent
@onready var path_follow: EnemyMovementComponent = $MovementComponent
@onready var sprite: Sprite2D = $Sprite2D
var target: Node2D

func _ready() -> void:
	sprite.texture = data.texture
	health.setup(data.max_health)
	health.died.connect(_on_died)
	target = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if target:
		var dist := global_position.distance_to(target.global_position)
		if dist < data.detection_range:
			velocity = path_follow.get_direction(target, delta) * data.speed
	move_and_slide()

func _on_died() -> void:
	queue_free()
