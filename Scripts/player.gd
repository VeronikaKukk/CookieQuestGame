extends CharacterBody2D

@export var movement_data : PlayerMovementData

const dash_speed = 500.0
var is_dashing = false
var can_dash = false

@onready var attack_collision_shape = $AttackArea/AttackCollisionShape
var is_attacking = false
var can_attack = false
var attack_damage = 1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var max_air_jumps = 0
var air_jumps = max_air_jumps

var health = 5:
	set(new_health):
		health = new_health
		if health < 0:
			Events.emit_signal("update_player_health", 0)
		else:
			Events.emit_signal("update_player_health", health)
var max_health = 5

@onready var animated_sprite =  $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var last_respawn_point = global_position

var is_dying = false
var is_getting_damaged = false

func _ready():
	Events.set_checkpoint.connect(set_checkpoint)
	Events.player_upgrade.connect(upgrade)
	call_deferred("set_begin_health")

func set_begin_health():# does it after everything is connected, otherwise heartsgui does it later and not show at start health
	Events.emit_signal("update_player_health", health)

func set_checkpoint(pos):
	last_respawn_point = pos

func upgrade(upgrade_name):
	if "one_jump" in upgrade_name:
		max_air_jumps += 1
	elif "high_jump" in upgrade_name:
		movement_data.jump_velocity -= 30
	elif "one_health" in upgrade_name:
		health+=1
		max_health+=1
	elif "dash" in upgrade_name:
		can_dash = true
	elif "damage" in upgrade_name:
		attack_damage += 1
	elif "one_speed" in upgrade_name:
		movement_data.speed += 20
	elif "attacking" in upgrade_name:
		can_attack = true

func _physics_process(delta):
	if Input.is_action_just_pressed("respawn"):
		die()
	if not is_dying:
		if Input.is_action_just_pressed("attack") and can_attack:
			can_attack = false
			attack_collision_shape.disabled = false
			is_attacking = true
			$AttackCooldownTimer.start()
			$AttackAudio.play()
		apply_gravity(delta)
		handle_jump()
		var input_axis = Input.get_axis("ui_left", "ui_right")
		handle_acceleration(input_axis, delta)
		apply_friction(input_axis, delta)
		apply_air_resistance(input_axis, delta)
		update_animations(input_axis)
		var was_on_floor = is_on_floor()
		move_and_slide()
		var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
		if just_left_ledge:
			coyote_jump_timer.start()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump():
	if is_on_floor(): air_jumps = max_air_jumps
	
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = movement_data.jump_velocity
			$JumpAudio.play()
	elif not is_on_floor():
		if Input.is_action_just_released("ui_up") and velocity.y < movement_data.jump_velocity / 2:
			velocity.y = movement_data.jump_velocity / 2
		if Input.is_action_just_pressed("ui_up") and air_jumps > 0:
			velocity.y = movement_data.jump_velocity
			air_jumps -= 1
			$JumpAudio.play()

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func apply_air_resistance(input_axis, delta):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)

func handle_acceleration(input_axis, delta):
	if Input.is_action_just_pressed("dash") and can_dash and input_axis!=0:
		is_dashing = true
		$DashAudio.play()
		$DashTimer.start()
		can_dash = false
		$DashCooldownTimer.start()
	if is_dashing:
		velocity.x = dash_speed * input_axis
	else:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)

func update_animations(input_axis):
	if not is_getting_damaged:
		if input_axis != 0:
			animated_sprite.flip_h = (input_axis < 0)
			if input_axis == 1:
				$AttackArea.scale = Vector2(1,1)
			else:
				$AttackArea.scale = Vector2(-1,1)
		if not is_attacking:
			if not is_on_floor():
				animated_sprite.play("jump")
			if is_on_floor() && input_axis != 0:
				animated_sprite.play("run")
				if $SoundTimer.time_left <= 0.1:
					$WalkAudio.pitch_scale = randf_range(0.7,1.2)
					$WalkAudio.play()
					$SoundTimer.stop()
					$SoundTimer.start()
			elif is_on_floor():
				animated_sprite.play("idle")
		else:
			animated_sprite.play("attack")
		

func _on_hazard_detector_area_entered(_area):
	health -=_area.damage_amount
	if health <= 0:
		die()
	elif not is_dying and not is_getting_damaged:
		is_getting_damaged = true
		animated_sprite.play("hit")
		$DamagedAudio.play()

func die():
	$DeathAudio.play()
	health = 0
	is_dying = true
	animated_sprite.play("death")
	await animated_sprite.animation_finished
	is_dying = false
	global_position = last_respawn_point
	health = max_health
	is_getting_damaged = false

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "hit":
		is_getting_damaged = false
	elif animated_sprite.animation == "attack":
		is_attacking = false
		attack_collision_shape.disabled = true
	

func _on_dash_timer_timeout():
	is_dashing = false


func _on_dash_cooldown_timer_timeout():
	can_dash = true

func _on_attack_area_body_entered(body):
	if body.is_in_group("Enemy"):
		body._got_hit(attack_damage)
		print("enemy detected")

func _on_attack_cooldown_timer_timeout():
	can_attack = true
