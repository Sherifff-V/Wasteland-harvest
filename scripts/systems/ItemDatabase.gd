extends Node

var _items: Dictionary = {}

const ITEMS_FOLDER := "res://data/items/"

func _ready() -> void:
	_load_items_from_folder(ITEMS_FOLDER)

func _load_items_from_folder(path: String) -> void:
	var dir := DirAccess.open(path)
	if not dir:
		push_error("ItemDatabase: couldnt open folder " + path)
		return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir():
			var clean_name := file_name.trim_suffix(".remap")
			if clean_name.ends_with(".tres") or clean_name.ends_with(".res"):
				var item := load(path.path_join(clean_name)) as ItemData
				if item and item.id != &"":
					_items[item.id] = item
		file_name = dir.get_next()

func create_item(id: StringName) -> ItemData:
	if _items.is_empty():
		_load_items_from_folder("res://data/items")
	if _items.has(id):
		return _items[id].duplicate()
	push_warning("ItemDatabase: item id not found: '" + str(id) + "'")
	return null
