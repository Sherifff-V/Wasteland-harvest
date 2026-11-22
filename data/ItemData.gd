class_name ItemData extends Resource
@export var id: StringName
@export var display_name: String
@export var icon: Texture2D
@export var max_stack: int = 999

func same_as(other: ItemData) -> bool:
	return other != null and id == other.id
