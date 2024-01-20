extends Control

@onready var goal_label = $GoalPanel/HBoxContainer/Label
@onready var goal_image = $GoalPanel/HBoxContainer/GoalImage

func _ready():
	Events.show_goal.connect(show_goal)

func show_goal(goal_text, item):
	if not visible:
		$ShowGoalTimer.start()
		$"../../ShowGoalAudio".play()
		visible = true
		goal_label.text = goal_text
		goal_image.texture = load(Inventory.image_paths[item])

func _on_show_goal_timer_timeout():
	visible = false
