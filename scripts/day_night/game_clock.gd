extends Node

signal time_changed(time_of_day: float)
signal day_passed(day: int)

const DAY_LENGTH := 1.0; # in seconds
const NIGHT_LENGTH := 2.0; # in seconds

var day_count := 1;
var time_length = DAY_LENGTH + NIGHT_LENGTH;
var global_time = 0.2;
var isPaused := false;

func _process(delta: float) -> void:
	if isPaused: return
	
	global_time += delta;
	time_changed.emit(global_time);
	
	if global_time > time_length:
		global_time = 0;
		day_count += 1;
		day_passed.emit(day_count);
		
func get_hour() -> float:
	return global_time * 24.0 / time_length;
	
func is_night() -> bool:
	return global_time > DAY_LENGTH;
	
