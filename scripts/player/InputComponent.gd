class_name InputComponent
extends Node
 
signal slot_selected(index: int)
signal mouse_hovering(pos: Vector2)
signal debug_checkinventorysig
signal left_click_pressed(world_pos: Vector2)
signal left_click_interact_pressed
signal interact_pressed


signal weapon_1_selected
signal weapon_2_selected
signal shoot_pressed
signal shoot_released

@export var ground_layer: TileMapLayer

@onready var player: Node2D = get_parent()
@onready var movement: MovementComponent = get_parent().get_node("MovementComponent")

const HOTBAR_SIZE := 5 # less or equal 9

var move_direction := Vector2.ZERO
var last_hovered_tile: Vector2i = Vector2i(-9999, -9999)
var shoot_pressed_state := false

func _unhandled_input(event: InputEvent) -> void:
	var mouse_pos = get_parent().get_global_mouse_position()
	var tile_pos: Vector2i = ground_layer.local_to_map(ground_layer.to_local(mouse_pos));

	for i in HOTBAR_SIZE:
		if event.is_action_pressed("slot_%d" % (i + 1)):
			slot_selected.emit(i)
			mouse_hovering.emit(tile_pos)

	if event.is_action_pressed("debug_checkinventory"):


	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_7:
			weapon_1_selected.emit()
		elif event.keycode == KEY_8:
			weapon_2_selected.emit()


	if event.is_action_pressed("slot_2"):
		mouse_hovering.emit(tile_pos)
	elif event.is_action_pressed("debug_checkinventory"):
		debug_checkinventorysig.emit()
	elif event.is_action_pressed("interact"):
		interact_pressed.emit()


	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				left_click_interact_pressed.emit()
				left_click_pressed.emit(mouse_pos)
				shoot_pressed.emit()
				shoot_pressed_state = true
			else:
				shoot_released.emit()
				shoot_pressed_state = false

	if event is InputEventMouseMotion or movement.is_moving(get_parent()):
		if tile_pos != last_hovered_tile:
			last_hovered_tile = tile_pos
			mouse_hovering.emit(tile_pos)


func _process(_delta: float) -> void:
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func is_shooting() -> bool:
	return shoot_pressed_state
