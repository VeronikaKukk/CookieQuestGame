extends CharacterBody2D

@export var movement_data : PlayerMovementData
@export var boundary_left_x : int
@export var boundary_right_x : int

@export var rewards = []

var chasing = false
var player = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var  is_getting_damaged = false
var is_dying = false
var health = 15:
	set(new_health):
		health = new_health
		if health <= 0:
			call_deferred("die")
		else:
			is_getting_damaged = true

func die():
	is_dying = true
	$DeathAudio.play()
	# spawn reward
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
		reward_scene.global_position = global_position
	$AnimatedSprite2D.play("death")
	queue_free()

func _physics_process(delta):
	apply_gravity(delta)
	if chasing:
		if player.global_position.x > boundary_left_x and player.global_position.x < boundary_right_x:
			velocity.x = (player.position - position).normalized().x * movement_data.speed
		if player.position.x - position.x < 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	else:
		velocity.x = 0
	if not is_getting_damaged and not is_dying:
		if velocity:
			$AnimatedSprite2D.play("run")
			move_and_slide()
		else:
			$AnimatedSprite2D.play("idle")
	elif not is_dying:
		$AnimatedSprite2D.play("damaged")

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _on_detect_player_area_body_entered(body):
	player = body
	chasing = true
	$AttackTimer.start()

func _on_detect_player_area_body_exited(_body):
	player = null
	chasing = false
	$AttackTimer.stop()

func _got_hit(damage_value):
	health -= damage_value
	$DamagedAudio.play()

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "damaged":
		is_getting_damaged = false


func _on_attack_timer_timeout():
	$HazardArea.visible = false
	$HazardArea.visible = true
	$AttackTimer.start()
	
