extends HBoxContainer

var required_items = []
var upgrade_name = ""
func update_item_pictures(items):
	required_items = items
	for i in range(3):
		if len(items) > i:
			get_node("Item"+str(i)).texture = load(Inventory.image_paths[items[i]])
		else:
			get_node("Item"+str(i)).texture = null

func update_upgrade_picture(upgrade_item, up_name):
	upgrade_name = up_name
	$UpgradePicture.texture = load(Inventory.image_paths[upgrade_item])

func update_craft_buttons():
	var isOk = true
	for item in required_items:
		if item not in Inventory.picked_up_items_names:
			isOk = false
	if isOk:
		$CraftButton.disabled = false
	else:
		$CraftButton.disabled = true

func _on_craft_button_pressed():
	$CraftedAudio.play()
	$UpgradeParticles.emitting = true
	for item in required_items:
		Inventory.remove_item(item)
	Events.emit_signal("player_upgrade",upgrade_name)
