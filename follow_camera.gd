extends Control

# thanks freya holmer
func exp_decay(a, b, decay, dt):
	return b+(a-b)*exp(-decay*dt)

func _process(delta: float):
	global_position = exp_decay(
		global_position,
		get_viewport().get_camera_2d().global_position + Vector2(0, -150),
		4, delta)
