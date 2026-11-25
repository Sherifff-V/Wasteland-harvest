class_name ShootingComponent
extends Node

@onready var player: CharacterBody2D = get_parent()
@onready var input: InputComponent = player.get_node("InputComponent")
@onready var inventory_comp: InventoryComponent = player.get_node("InventoryComponent")

@export var muzzle: Marker2D  

var _weapon: WeaponData = null
var _cooldown_left := 0.0
var _trigger_held := false

func _ready() -> void:
	input.left_click_pressed.connect(_on_left_click)
	inventory_comp.selected_changed.connect(_on_selection_changed)
	inventory_comp.deselect.connect(_on_deselected)

func _on_selection_changed(_index: int) -> void:
	_refresh_weapon()

func _on_deselected(_index: int) -> void:
	_weapon = null
	_trigger_held = false

func _refresh_weapon() -> void:
	_weapon = null
	_trigger_held = false 
	if inventory_comp.selected_index < 0:
		return
	var slot := inventory_comp.get_selected()
	if slot != null and slot.item is WeaponData:
		_weapon = slot.item as WeaponData


func _on_left_click(world_pos: Vector2) -> void:
	if _weapon == null:
		return              
	_trigger_held = true
	_try_shoot(world_pos)

func _process(delta: float) -> void:
	_cooldown_left = maxf(_cooldown_left - delta, 0.0)
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_trigger_held = false
	if _weapon != null and _weapon.auto and _trigger_held:
		_try_shoot(player.get_global_mouse_position())


func _try_shoot(aim_pos: Vector2) -> void:
	if _weapon == null or _cooldown_left > 0.0:
		return


	var ammo: ItemData = ItemDatabase.create_item(_weapon.ammo_id)
	if ammo == null:
		return


	if not inventory_comp.inventory.remove(ammo, 1):
		print("Нет патронов")   
		_cooldown_left = 0.35
		return

	_cooldown_left = _weapon.cooldown

	var origin := muzzle.global_position if muzzle != null else player.global_position
	var dir := (aim_pos - origin).normalized()

	for i in _weapon.pellets:
		var angle := deg_to_rad(randf_range(-_weapon.spread, _weapon.spread))
		var bullet := _weapon.bullet_scene.instantiate() as Bullet
		get_tree().current_scene.add_child(bullet)
		bullet.setup(origin + dir.rotated(angle) * 8.0, dir.rotated(angle), _weapon.damage, player)
