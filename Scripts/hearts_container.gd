extends HBoxContainer


@onready var heart_GUI_class = preload("res://Scenes/health_gui.tscn")

func _ready():
	Events.update_player_health.connect(update_health)

func update_health(value):
	var ch = get_children()
	for i in range(len(ch)):
		remove_child(ch[i])
	
	for i in range(value):
		var heart = heart_GUI_class.instantiate()
		add_child(heart)
