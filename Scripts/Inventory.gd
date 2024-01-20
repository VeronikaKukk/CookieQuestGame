extends Node

var picked_up_items = []
var picked_up_items_names = []
var time_end = 0.0
@export var image_paths = {"apple":"res://Graphics/objects/yellowapple.png",
"strawberry":"res://Graphics/objects/Strawberry.png",
"sugar":"res://Graphics/objects/sugar.png",
"apple pie":"res://Graphics/objects/05_apple_pie.png",
"pretty apple":"res://Graphics/objects/speicalapple.png",
"golden key":"res://Graphics/objects/key.png",
"pretty strawberry":"res://Graphics/objects/speicalstrawberry.png",
"strawberry cake":"res://Graphics/objects/90_strawberrycake.png",
"fruit jam":"res://Graphics/objects/jam_strawberry.png",
"fruit cake":"res://Graphics/objects/46_fruitcake.png",
"chest key":"res://Graphics/objects/key2.png",
"cookie":"res://Graphics/objects/28_cookies.png",
"chocolate":"res://Graphics/objects/26_chocolate.png"
}
@export var upgrade_to_name = { "one_jump":"apple pie",
"high_jump":"pretty apple", "one_health":"pretty strawberry","dash":"strawberry cake",
"damage":"fruit jam", "one_speed":"fruit cake", "attacking":"cookie"
}

func add_item(item_name, image):
	picked_up_items.append([item_name,image])
	picked_up_items_names.append(item_name)
	Events.update_inventory.emit()
	
func remove_item(item_name):
	picked_up_items_names.erase(item_name)
	for i in range(picked_up_items.size()):
		var currentItem = picked_up_items[i]
		if currentItem[0] == item_name:
			picked_up_items.remove_at(i)
			break
	Events.update_inventory.emit()
