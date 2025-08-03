extends Path2D

@export var segment_interval = 6.0
@export var gradient: Gradient

@onready var camera = $Camera

var first_segment: RigidBody2D = null
var last_segment: RigidBody2D = null
func _ready():
	add_whimsy(Global.extra_whimsy)
	Global.extra_whimsy = 0
	var total_length := curve.get_baked_length()
	var offset := total_length
	var prev_segment = null
	while(offset > 0):
		var t := curve.sample_baked_with_rotation(offset)
		prev_segment = spawn_segment(t, prev_segment)
		if(first_segment == null):
			first_segment = prev_segment
		offset -= segment_interval
	last_segment = prev_segment
	$Camera/Camera.position_smoothing_enabled = false
	last_segment.make_tail()
	_process(INF)
	#$Camera/Camera.set_deferred("position_smoothing_enabled", true)

func spawn_segment(t: Transform2D, prev_segment):
	var next_segment := preload("res://eel_segment.tscn").instantiate()
	next_segment.gradient = gradient
	add_child(next_segment)
	next_segment.global_transform = t
	if(is_instance_valid(prev_segment)):
		var pin_joint := PinJoint2D.new()
		pin_joint.node_a = prev_segment.get_path()
		pin_joint.node_b = next_segment.get_path()
		next_segment.add_child(pin_joint)
		pin_joint.global_position = (prev_segment.global_position + next_segment.global_position)/2
	return next_segment

func grow():
	last_segment = spawn_segment(
		last_segment.global_transform
			.translated(segment_interval*Vector2.LEFT.rotated(last_segment.rotation)),
		last_segment
	)

func _physics_process(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	first_segment.apply_force(input_direction*delta*10000)

# thanks freya holmer
func exp_decay(a, b, decay, dt):
	return b+(a-b)*exp(-decay*dt)

var show_whimsy: bool = false
@onready var overhead = $Overhead
func _process(delta: float):
	camera.position = first_segment.position*0.75+last_segment.position*0.25
	if(show_whimsy):
		overhead.position = exp_decay(
			overhead.position,
			get_viewport().get_camera_2d().global_position - (overhead.size*overhead.scale)/2,
			6, delta
		)
		overhead.scale = exp_decay(overhead.scale, Vector2(2, 2), 6, delta)
	else:
		overhead.position = exp_decay(
			overhead.position,
			first_segment.position - overhead.size/2 + Vector2(0, -40),
			6, delta
		)
		overhead.scale = exp_decay(overhead.scale, Vector2(1, 1), 6, delta)
	%WhimsyProgress.size.x = exp_decay(
		%WhimsyProgress.size.x,
		(float(whimsy)/float(required_whimsy))*160,
		12, delta)

var whimsy := 0
var required_whimsy = 10
func add_whimsy(w: int):
	whimsy += w

func set_clock(t: float):
	%ClockHand.rotation = -t*(2.0*PI)
