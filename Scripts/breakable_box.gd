extends Node2D

@export var rewards = []
var is_broken = false
@onready var animated_sprite_2d = $AnimatedSprite2D
var is_getting_damaged = false
var health = 2:
	set(new_health):
		health = new_health
		if health <= 0:
			animated_sprite_2d.play("death")
			call_deferred("drop_rewards")
		else:
			is_getting_damaged = true
			
func drop_rewards():
	is_broken = true
	var i = 15
	for reward in rewards:
		var reward_scene = load("res://Scenes/collectable.tscn").instantiate()
		reward_scene.collectable_name = reward
		reward_scene.image = load(Inventory.image_paths[reward])
		var collision_shape = CollisionShape2D.new()
		var circle_shape = CircleShape2D.new()
		circle_shape.radius = 10
		collision_shape.shape = circle_shape
		reward_scene.add_child(collision_shape)
		get_node("/root/GameWorld/Levels/Level/Items").add_child(reward_scene)
		reward_scene.global_position = global_position+ Vector2(i,0)
		i+=5
	queue_free()

func _process(delta):
	if not is_getting_damaged and not is_broken:
		$AnimatedSprite2D.play("idle")
	elif not is_broken:
		$AnimatedSprite2D.play("hit")

func _got_hit(damage_value):
	if not is_broken:
		health -= damage_value
	
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "hit":
		is_getting_damaged = false
