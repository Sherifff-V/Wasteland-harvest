class_name InventorySlot extends RefCounted
var item: ItemData
var amount := 0

func is_empty() -> bool:
	return item == null
