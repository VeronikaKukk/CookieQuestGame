extends Node2D

@onready var actionable = $actionable
@onready var animated_sprite_2d = $AnimatedSprite2D


@export var needed_object = ""
@export var rewards = []
var is_collected = false
func _ready():
	actionable.interact = Callable(self, "_on_interact")

func _on_interact():
	if not is_collected:
		if needed_object in Inventory.picked_up_items_names or needed_object == "":
			if needed_object != "":
				Inventory.remove_item(needed_object)
			animated_sprite_2d.play("opening")
			$OpenChestAudio.play()
			is_collected = true
			var i = 5
			for reward in rewards:
				var reward_scene = load("res://Scenes/collectable.tscn").instantiate()
				reward_scene.collectable_name = reward
				reward_scene.image = load(Inventory.image_paths[reward])
				var collision_shape = CollisionShape2D.new()
				var circle_shape = CircleShape2D.new()
				circle_shape.radius = 10
				collision_shape.shape = circle_shape
				reward_scene.add_child(collision_shape)
				reward_scene.position = reward_scene.position + Vector2(-i,-10)
				i+=5
				add_child(reward_scene)
			actionable.queue_free()
		else:
			Events.emit_signal("show_goal","Get the "+needed_object, needed_object)
