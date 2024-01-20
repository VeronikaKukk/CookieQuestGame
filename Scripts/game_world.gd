extends Node

@export var start_scene: String
var current_level:Node2D
@onready var transition = $CanvasLayer/Transition
var time_elapsed = 0.0
func _ready():
	current_level = load(start_scene).instantiate()
	$Levels.add_child(current_level)
	current_level.connect("goto_room", _on_goto_room)
	$Player.global_position = current_level.player_start_pos

func _on_goto_room(scene):
	Inventory.time_end = time_elapsed
	get_tree().paused = true
	#var new_level = scene.instantiate()
	transition.fade_to_black()
	#$Levels.add_child(new_level)
	#current_level.queue_free()
	#current_level = new_level
	#new_level.connect("goto_room", _on_goto_room)
	transition.fade_from_black()
	get_tree().paused = false
	#$Player.global_position = current_level.player_start_pos
	get_tree().change_scene_to_file(scene)

func _process(delta):
	time_elapsed+=delta
