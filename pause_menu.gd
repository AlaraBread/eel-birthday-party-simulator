extends Control

func _on_unpause_pressed():
	get_tree().paused = false
	visible = get_tree().paused
	if(visible):
		$Unpause.grab_focus()

func _input(event):
	if(event.is_action_pressed("pause")):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		if(visible):
			$Unpause.grab_focus()
