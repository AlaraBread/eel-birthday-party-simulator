extends Camera2D

var remaining_shakes = 0
func shake():
	remaining_shakes = 4
	randomize_position()
	$ShakeTimer.start()

func _on_shake_timer_timeout():
	remaining_shakes -= 1
	if(remaining_shakes <= 0):
		position = Vector2()
	else:
		randomize_position()
		$ShakeTimer.start()

func randomize_position():
	position = 10*Vector2.UP.rotated(randf_range(0, 2*PI))
