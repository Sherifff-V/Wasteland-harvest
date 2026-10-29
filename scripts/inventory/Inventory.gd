class_name Inventory extends RefCounted

signal slot_changed(index: int)

var slots: Array[InventorySlot] = []

func _init(size: int = 3) -> void:
	for i in size:
		slots.append(InventorySlot.new())

## returns how many items did not fit
func add(item: ItemData, amount: int = 1) -> int:
	# top up existing stacks
	for i in slots.size():
		var s := slots[i]
		
		if s.item == item and s.amount < item.max_stack:
			var moved := mini(amount, item.max_stack - s.amount)
			s.amount += moved
			amount -= moved
			
			slot_changed.emit(i)
			
			if amount == 0: return 0
			
	# fill empty slots
	for i in slots.size():
		var s := slots[i]
		
		if s.is_empty():
			var moved := mini(amount, item.max_stack)
			s.item = item
			s.amount = moved
			amount -= moved
			
			slot_changed.emit(i)
			
			if amount == 0: return 0
			
	return amount

## returns amount of given item
func count(item: ItemData) -> int:
	var total := 0
	
	for s in slots:
		if s.item == item: total += s.amount
		
	return total

## removes given amount of item from inventory, returns true if succeeded
func remove(item: ItemData, amount: int = 1) -> bool:
	if count(item) < amount:
		return false
		
	for i in slots.size():
		var s := slots[i]
		
		if s.item != item: continue
		
		var taken := mini(amount, s.amount)
		s.amount -= taken
		amount -= taken
		
		if s.amount == 0: s.item = null
		slot_changed.emit(i)
		
		if amount == 0: break
	return true
