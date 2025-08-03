extends Control

func _ready():
	$Play.grab_focus()

func _on_play_pressed():
	Global.year = 0
	get_tree().change_scene_to_file("res://level.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://menu/settings.tscn")
