extends PanelContainer

@export var hint: UIComponent
var _tween: Tween

func _ready() -> void:
	modulate.a = 0.0
	hide()
	hint.harvestable_nearby_changed.connect(_on_changed)

func _on_changed(is_near: bool) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	if is_near:
		show()
		_tween.tween_property(self, "modulate:a", 1.0, 0.15)
	else:
		_tween.tween_property(self, "modulate:a", 0.0, 0.15)
		_tween.tween_callback(hide)
