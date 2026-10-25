class_name InputComponent
extends Node
 
var move_direction := Vector2.ZERO
 
func _process(_delta: float) -> void:
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
