class_name Player
extends CharacterBody2D
 
@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
 
func _physics_process(delta: float) -> void:
	movement_component.move(self, input_component.move_direction, delta)
