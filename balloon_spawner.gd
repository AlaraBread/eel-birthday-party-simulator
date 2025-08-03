extends Marker2D

@export var balloon_colors: Array[Color]

const radius = 200

var balloon_count := 0

func _ready():
	for i in range(50):
		_on_timer_timeout()

func _on_timer_timeout():
	if(balloon_count > 100):
		return
	var balloon = preload("res://balloon.tscn").instantiate()
	add_child(balloon)
	balloon.popped.connect(_on_balloon_pop)
	balloon.global_position = global_position+\
			radius*randf()*Vector2.UP.rotated(randf_range(0, 2*PI))
	balloon.set_color(balloon_colors[randi()%len(balloon_colors)])
	balloon.rotation = randf_range(0, 2*PI)
	var s = randf_range(1.0, 1.2)
	balloon.scale = Vector2(s, s)

@onready var eel = get_node("../Eel")
func _on_balloon_pop():
	balloon_count -= 1
	eel.add_whimsy(1)

@onready var rope = %Rope

func _physics_process(delta):
	global_position = rope.avg_position
