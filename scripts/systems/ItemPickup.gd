class_name ItemPickup extends Area2D

@export var item_id: StringName
@export var amount := 1
@export var pickup_delay := 0.5 # after being dropped, can't be grabbed for this long
@export var lifetime := 0.0 # seconds before it disappears (0 = never)

@onready var sprite: Sprite2D = $Sprite2D
var _delay := 0.0
var item: ItemData

## creates the item on the floor
static func spawn(tree: SceneTree, drop_id: StringName, count: int, pos: Vector2) -> ItemPickup:
	var parent := tree.get_first_node_in_group("drops")
	if parent == null:
		push_error("No node in group 'drops'")
		return null
		
	var p: ItemPickup = load("res://scenes/item_pickup.tscn").instantiate()
	p.item_id = drop_id
	p.amount = count
	parent.add_child(p)
	p.global_position = pos
	p.toss()
	return p

func _ready() -> void:
	item = ItemDatabase.create_item(item_id)
	sprite.texture = item.icon
	_delay = pickup_delay
	_start_bob()
	if lifetime > 0.0:
		get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	if _delay > 0.0:
		_delay -= delta
		return
	for body in get_overlapping_bodies():
		if body.has_method("collect"):
			var left: int = body.collect(item.id, amount)
			if left <= 0:
				queue_free()
				return
			amount = left # rest stays on the floor

func toss() -> void: # spread away from drop point
	var land := global_position + Vector2.from_angle(randf() * TAU) * randf_range(9.0, 20.0)
	create_tween().tween_property(self, "global_position", land, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _start_bob() -> void: # floating
	var t := create_tween().set_loops()
	t.tween_property(sprite, "position:y", -3.0, 0.6).set_trans(Tween.TRANS_SINE)
	t.tween_property(sprite, "position:y", 0.0, 0.6).set_trans(Tween.TRANS_SINE)
