extends Area2D
@export var target_scene_path: String

signal player_entered

func _on_body_entered(_body):
	player_entered.emit(target_scene_path)
