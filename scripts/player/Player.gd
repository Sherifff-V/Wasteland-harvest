class_name Player extends CharacterBody2D

@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var gameClock: GameClock = $"/root/GameClock"

signal mouse_pos(pos: Vector2);

func _ready() -> void:
	gameClock.day_passed.connect(onDayPassed);
 
func onDayPassed(day: int) -> void:
	print("day passed: %d" %day);

func _physics_process(delta: float) -> void:
	movement_component.move(self, input_component.move_direction, delta)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		mouse_pos.emit(get_global_mouse_position()) # something would happen
