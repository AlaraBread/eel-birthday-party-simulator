extends Node2D

func _ready():
	$BirthdayTimer.wait_time = max(-15*log(float(Global.year)+1.0)+60, 10)
	$Eel.required_whimsy = 30*log(float(Global.year)+10)-20
	$BirthdayTimer.start()
	%YearLabel.text = "you lasted " + str(Global.year) + " years"

func _process(delta):
	$Eel.set_clock($BirthdayTimer.time_left/$BirthdayTimer.wait_time)
	if($BirthdayTimer.time_left <= 10):
		$Eel.show_whimsy = $Eel.whimsy < $Eel.required_whimsy

func _on_birthday_timer_timeout():
	get_tree().paused = true
	%PauseMenu.visible = false
	if($Eel.whimsy >= $Eel.required_whimsy):
		%WinMenu.visible = true
		%WinMenu/NextLevel.grab_focus()
		$YayPlayer.play()
		Global.extra_whimsy = max($Eel.whimsy-$Eel.required_whimsy, 0)
	else:
		%LoseMenu.visible = true
		%LoseMenu/MainMenu.grab_focus()
