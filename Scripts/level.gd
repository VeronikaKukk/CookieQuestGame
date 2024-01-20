extends Node2D

signal goto_room(room)

@export var player_start_pos = Vector2(100.0,100.0)
func _ready():
	Events.emit_signal("set_checkpoint", player_start_pos)
	var transition_areas = get_tree().get_nodes_in_group("TransitionArea")
	for transition in transition_areas:
		transition.player_entered.connect(transition_room)

func transition_room(target_scene_path):
	emit_signal("goto_room",target_scene_path)
