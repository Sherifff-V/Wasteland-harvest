class_name Player extends CharacterBody2D

@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var gameClock: GameClock = $"/root/GameClock"




func _ready() -> void:
	gameClock.day_passed.connect(onDayPassed);
 
func onDayPassed(day: int) -> void:
	#print("day passed: %d" %day);
	pass

func _physics_process(delta: float) -> void:
	movement_component.move(self, input_component.move_direction, delta)
	
