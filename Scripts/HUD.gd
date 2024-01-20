extends CanvasLayer

func _ready():
	Events.update_inventory.connect(_on_update_inventory)

func _on_update_inventory():
	for c in $InventoryDisplay/HBoxContainer.get_children():
		$InventoryDisplay/HBoxContainer.remove_child(c)
		c.queue_free()
	for el in Inventory.picked_up_items:
		var slot = load("res://Scenes/inventory_slot.tscn").instantiate()
		var textureRect = slot.get_node("Image")
		textureRect.texture = load(el[1])
		$InventoryDisplay/HBoxContainer.add_child(slot)
