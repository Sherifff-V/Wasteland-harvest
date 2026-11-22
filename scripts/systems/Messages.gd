extends Node

signal posted(text: String, color: Color)

var _last := {} # text -> posted time

## cooldown > 0 ignores the same text if it was posted less than that many seconds ago
func post(text: String, color: Color = Color.WHITE, cooldown: float = 0.0) -> void:
	if cooldown > 0.0:
		var now := Time.get_ticks_msec() / 1000.0
		if now - float(_last.get(text, -1000.0)) < cooldown:
			return
		_last[text] = now
	posted.emit(text, color)
