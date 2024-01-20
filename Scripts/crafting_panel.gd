extends Control

@onready var v_box_container = $Panel/VBoxContainer

var all_recipes = {
	"attacking":["sugar", "chocolate","Gain attacking ability","cookie"],
	"dash":["strawberry","sugar","Gain dash ability","strawberry cake"],
	"one_jump":["apple","sugar","Gain extra jump","apple pie"],
	"high_jump":["apple","Gain extra jump height","pretty apple"],
	"one_health":["strawberry","Gain extra health","pretty strawberry"],
	"damage":["strawberry","apple","Gain extra attack damage","fruit jam"],
	"one_speed":["sugar","strawberry","apple","Gain extra run speed","fruit cake"]
	}

var available_recipes = all_recipes
var crafted_count = {"one_jump":0, "high_jump":0,"one_health":0,"dash":0, "damage":0,"one_speed":0,"attacking":0}

func _ready():
	Events.open_crafting.connect(show_crafting_panel)
	Events.close_crafting.connect(_on_button_pressed)
	Events.update_inventory.connect(update_panel)
	Events.player_upgrade.connect(check_update_recipes)
	create_recipes()
	
func create_recipes():
	clear_panel()
	for key in available_recipes.keys():
		var recipe = all_recipes[key]
		var items = len(recipe)-2
		
		var slot = load("res://Scenes/crafting_slot.tscn").instantiate()
		slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		v_box_container.add_child(slot)
		
		slot.update_item_pictures(recipe.slice(0, items))
		slot.update_upgrade_picture(recipe[-1], key)

		slot.get_node("UpgradeText").text = recipe[-2]
	update_panel()

func check_update_recipes(upgrade_name):
	crafted_count[upgrade_name] += 1
	if crafted_count[upgrade_name] >= 2 or "dash" in upgrade_name or "attacking" in upgrade_name:# cant craft more than two times
		available_recipes.erase(upgrade_name)
		create_recipes()
	if "dash" in upgrade_name or "attacking" in upgrade_name:
		show_info_panel(upgrade_name)

func show_info_panel(upgrade_name):
	$InfoPanel.visible = true
	$ShowInfoTimer.start()
	if "attacking" in upgrade_name:
		$InfoPanel/HBoxContainer/infotext.text = "You gained attack with CTRL button (1s cooldown)."
	else:
		$InfoPanel/HBoxContainer/infotext.text = "You gained dash with left SHIFT button (5s cooldown)."
	

func _on_button_pressed():
	if $Panel.visible:
		$CloseCraftingAudio.play()
		$Panel.visible = false

func show_crafting_panel():
	$OpenCraftingAudio.play()
	$Panel.visible = true
	visible = true

func update_panel():
	for c in $Panel/VBoxContainer.get_children():
		c.update_craft_buttons()

func clear_panel():
	for c in $Panel/VBoxContainer.get_children():
		$Panel/VBoxContainer.remove_child(c)
		c.queue_free()

func _on_show_info_timer_timeout():
	$InfoPanel.visible = false
