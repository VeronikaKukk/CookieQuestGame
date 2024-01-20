extends Control

@onready var menu = $Menu
@onready var options = $Options
@onready var video = $Video
@onready var audio = $Audio
func _ready():
	$Audio/HBoxContainer/Sliders/Master.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$Audio/HBoxContainer/Sliders/Music.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$Audio/HBoxContainer/Sliders/SoundFX.value = db_to_linear(AudioServer.get_bus_volume_db(2))

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/game_world.tscn")

func _on_options_pressed():
	show_and_hide(options, menu)

func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_quit_pressed():
	get_tree().quit()

func _on_video_pressed():
	show_and_hide(video, options)

func _on_audio_pressed():
	show_and_hide(audio, options)

func _on_back_from_options_pressed():
	show_and_hide(menu, options)


func _on_full_screen_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif button_pressed == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_borderless_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	elif button_pressed == false:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)


func _on_v_sync_toggled(button_pressed):
	if button_pressed == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	elif button_pressed == false:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_back_from_video_pressed():
	show_and_hide(options,video)


func _on_master_value_changed(value):
	volume(0,value)

func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _on_music_value_changed(value):
	volume(1,value)


func _on_sound_fx_value_changed(value):
	volume(2,value)


func _on_back_from_audio_pressed():
	show_and_hide(options, audio)
