extends Control

@onready var updrage_slot = preload("res://Scenes/upgrade_sprite.tscn")

func _ready():
	Events.player_upgrade.connect(show_player_upgrade)

func show_player_upgrade(value):
	var ch = get_children()
	var upgrade = updrage_slot.instantiate()
	upgrade.texture = load(Inventory.image_paths[Inventory.upgrade_to_name[value]])
	$Panel/HBoxContainer.add_child(upgrade)
