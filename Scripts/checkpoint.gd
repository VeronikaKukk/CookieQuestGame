extends AnimatedSprite2D

@onready var actionable = $actionable
@onready var animated_sprite = $"."

var isBurning = false

func _ready():
	actionable.interact = Callable(self, "_on_interact")
	
func _on_interact():
	if not isBurning:
		animated_sprite.play("fire_start")
		isBurning = true
		actionable.action_name = "end fire"
		Events.emit_signal("set_checkpoint", global_position+Vector2(-25,0))
		Events.emit_signal("open_crafting")
		$FireSound.play()
	else:
		animated_sprite.play("fire_end")
		isBurning = false
		actionable.action_name = "start fire"
		Events.emit_signal("close_crafting")
		$FireSound.stop()
	await animated_sprite.animation_finished
	if isBurning:
		animated_sprite.play("fire_loop")

func _on_actionable_body_exited(_body):
	Events.emit_signal("close_crafting")
