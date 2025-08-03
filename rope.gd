extends Path2D

@export var segment_interval = 3.0
@export var close_loop = true
@export var gradient: Gradient

var first_segment: RigidBody2D = null
var last_segment: RigidBody2D = null
func _ready():
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

	var pin_joint := PinJoint2D.new()
	pin_joint.node_a = first_segment.get_path()
	pin_joint.node_b = last_segment.get_path()
	first_segment.add_child(pin_joint)
	pin_joint.global_position = (first_segment.global_position + last_segment.global_position)/2

func spawn_segment(t: Transform2D, prev_segment):
	var next_segment := preload("res://rope_segment.tscn").instantiate()
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

var avg_position := Vector2()
func _physics_process(delta):
	avg_position = Vector2()
	for segment: RigidBody2D in get_children():
		avg_position += segment.global_position
	avg_position /= get_child_count()
	for segment: RigidBody2D in get_children():
		segment.apply_force(
			(segment.global_position-avg_position).normalized()*50*delta
		)
