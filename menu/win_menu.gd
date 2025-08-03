extends Control

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")

func _on_next_level_pressed():
	Global.year += 1
	get_tree().paused = false
	get_tree().reload_current_scene()
