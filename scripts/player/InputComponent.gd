class_name InputComponent
extends Node
 
signal slot_selected(index: int)
const HOTBAR_SIZE := 2 

var move_direction := Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if HOTBAR_SIZE > 9: printerr("Hotbar size must be <= 9")
	
	for i in HOTBAR_SIZE:
		if event.is_action_pressed("slot_%d" % (i + 1)):
			slot_selected.emit(i)

func _process(_delta: float) -> void:
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
