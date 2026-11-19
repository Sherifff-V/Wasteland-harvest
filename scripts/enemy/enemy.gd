class_name Enemy extends CharacterBody2D

@export var data: EnemyData
@onready var health: EnemyHealthComponent = $HealthComponent
@onready var movement: EnemyMovementComponent = $MovementComponent
@onready var sprite: Sprite2D = $Sprite2D
var target: Node2D

func _ready() -> void:
	sprite.texture = data.texture
	health.setup(data.max_health)
	health.died.connect(_on_died)
	target = get_tree().get_first_node_in_group("player")
	movement.player_range = data.detection_range
	movement.reached_goal.connect(_on_reached_goal)


func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if target:
		velocity = movement.get_direction(target, delta) * data.speed
	move_and_slide()

func _on_reached_goal(goal: Node2D) -> void:
	print(name, " reached ", goal.name)   # eat/damage the crop here later

func _on_died() -> void:
	queue_free()
