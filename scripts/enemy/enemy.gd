class_name Enemy extends CharacterBody2D

@export var data: EnemyData
@onready var health_comp: HealthSystem = $HealthComponent
@onready var movement: EnemyMovementComponent = $MovementComponent
@onready var damage_comp: EnemyDamageComponent = $DamageComponent
@onready var sprite: Sprite2D = $Sprite2D
var target: Node2D

func _ready() -> void:
	sprite.texture = data.texture
	health_comp.setup(data.max_health)
	health_comp.died.connect(_on_died)
	target = get_tree().get_first_node_in_group("player")
	movement.player_range = data.detection_range
	movement.enemy_attack_reach = data.attack_reach
	movement.reached_goal.connect(_on_reached_goal)
	damage_comp.attack_interval = data.attack_interval

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if target:
		velocity = movement.get_direction(target, delta) * data.speed
	move_and_slide()
	_attack()

func _on_reached_goal(goal: Node2D) -> void:
	#print(name, " reached ", goal.name)
	_attack()

func _attack() -> void:
	if movement.reached and is_instance_valid(movement.goal):
		damage_comp.try_attack(movement.goal)
		return
	
	if target and global_position.distance_to(target.global_position) <= data.attack_reach:
		damage_comp.try_attack(target)
			
func _on_died() -> void:
	print("enemy killed the player")
	queue_free()
