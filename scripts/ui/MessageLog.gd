extends VBoxContainer

@export var lifetime := 3.0 # seconds a message stays visible
@export var fade_time := 0.5
@export var max_messages := 8

const pixel_font = preload("res://data/fonts/PixelifySans-VariableFont_wght.ttf")

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	Messages.posted.connect(_on_posted)

func _on_posted(text: String, color: Color) -> void:
	var label := Label.new()
	label.text = text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_override("font", pixel_font)
	label.add_theme_font_size_override("font_size", 16)
	add_child(label)

	while get_child_count() > max_messages: # drop the oldest
		var old := get_child(0)
		remove_child(old)
		old.queue_free()

	var t := label.create_tween()
	t.tween_interval(lifetime)
	t.tween_property(label, "modulate:a", 0.0, fade_time)
	t.tween_callback(label.queue_free)
