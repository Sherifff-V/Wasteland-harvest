class_name InputComponent
extends Node
 
signal slot_selected(index: int)
signal mouse_hovering(pos: Vector2)
signal mouse_right_click(pos: Vector2)

@export var ground_layer: TileMapLayer

const HOTBAR_SIZE := 2 

var move_direction := Vector2.ZERO
var last_hovered_tile: Vector2i = Vector2i(-9999, -9999)

func _unhandled_input(event: InputEvent) -> void:
	if HOTBAR_SIZE > 9: printerr("Hotbar size must be <= 9")
	
	for i in HOTBAR_SIZE:
		if event.is_action_pressed("slot_%d" % (i + 1)):
			slot_selected.emit(i)
			
	var mouse_pos = get_parent().get_global_mouse_position()
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		mouse_right_click.emit(mouse_pos)
	
	if event is InputEventMouseMotion:
		var tile: Vector2i = ground_layer.local_to_map(ground_layer.to_local(mouse_pos));
		
		if tile != last_hovered_tile:
			last_hovered_tile = tile
			mouse_hovering.emit(tile)


func _process(_delta: float) -> void:
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
