extends Camera2D

var remaining_shakes = 0
func shake():
	remaining_shakes = 4
	randomize_position()
	timer_running = true
	timer = 0

var target_pos := Vector2()
func _on_shake_timer_timeout():
	remaining_shakes -= 1
	if(remaining_shakes <= 0):
		target_pos = Vector2()
		timer_running = false
	else:
		randomize_position()
		timer = 0

# thanks freya holmer
func exp_decay(a, b, decay, dt):
	return b+(a-b)*exp(-decay*dt)

var timer_running = false
var timer: float = 0
func _process(delta):
	position = exp_decay(position, target_pos, 40, delta)
	if(timer_running):
		timer += delta
	if(timer > 0.02):
		timer = 0
		_on_shake_timer_timeout()

func randomize_position():
	target_pos = 15*Vector2.UP.rotated(randf_range(0, 2*PI))
