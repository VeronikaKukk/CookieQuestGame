extends Node2D

@onready var actionable = $actionable
@onready var animated_sprite = $"."

@export var needed_object = ""

func _ready():
	actionable.interact = Callable(self, "_on_interact")
	
func _on_interact():
	if needed_object in Inventory.picked_up_items_names:
		Inventory.remove_item(needed_object)
		# play animation for moving it down
		queue_free()
	else:
		Events.emit_signal("show_goal","Get the "+needed_object, needed_object)
