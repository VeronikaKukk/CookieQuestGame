extends CharacterBody2D

@export var movement_data : PlayerMovementData
@export var boundary_left_x : int
@export var boundary_right_x : int
var chasing = false
var player = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var  is_getting_damaged = false
var is_dying = false
var health = 5:
	set(new_health):
		health = new_health
		if health <= 0:
			die()
		else:
			is_getting_damaged = true

func die():
	is_dying = true
	$AnimatedSprite2D.play("death")
	$DeathAudio.play()

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
		$DamagedAudio.play()
		$AnimatedSprite2D.play("damaged")

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _on_detect_player_area_body_entered(body):
	player = body
	chasing = true

func _on_detect_player_area_body_exited(_body):
	player = null
	chasing = false

func _got_hit(damage_value):
	health -= damage_value


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "damaged":
		is_getting_damaged = false
	elif $AnimatedSprite2D.animation == "death":
		queue_free()
