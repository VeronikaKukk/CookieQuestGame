extends Area2D

@export var collectable_name = "Coin"
@export var image: Texture
@onready var animation_player = $Sprite2D/AnimationPlayer


func _ready():
	$Sprite2D.texture = image
	animation_player.play("item_floating")

func _on_body_entered(_body):
	$PickUpAudio.play()
	Inventory.add_item(collectable_name,$Sprite2D.texture.resource_path)
	


func _on_pick_up_audio_finished():
	queue_free()
