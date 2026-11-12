extends Node

signal time_changed(time_of_day: float)
signal day_passed(day: int)

var environment_gradient: Gradient = preload("res://data/day_night_gradient.tres")
var light_modifier: CanvasModulate = null

const DAY_LENGTH := 20.0; # in seconds
const NIGHT_LENGTH := 10.0; # in seconds

var day_count := 1;
var time_length = DAY_LENGTH + NIGHT_LENGTH;
var global_time = 0.2;
var isPaused := false;

func _process(delta: float) -> void:
	if isPaused: return
	
	global_time += delta;
	
	if not light_modifier:
		var current_scene = get_tree().current_scene
		if current_scene:
			light_modifier = current_scene.find_child("Ambient", true, false) as CanvasModulate

	var time_percent: float = global_time / time_length
	
	if environment_gradient and light_modifier:
		light_modifier.color = environment_gradient.sample(time_percent)
	
	
	if global_time > time_length:
		global_time = 0;
		day_count += 1;
		day_passed.emit(day_count);
		
func get_hour() -> float:
	return global_time * 24.0 / time_length;
	
func is_night() -> bool:
	return global_time > DAY_LENGTH;
	
func is_day() -> bool:
	return !is_night()
	
