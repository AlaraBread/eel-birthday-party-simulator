class_name EelSegment
extends RigidBody2D

var gradient: Gradient

@onready var time = randf()

func _ready():
	$ColorRect.size.y = randf_range(15, 20)
	$ColorRect.position.y = -$ColorRect.size.y/2

func make_tail():
	$ColorRect.size.y = 10
	$ColorRect.size.x = 20
	$ColorRect.position.y = -$ColorRect.size.y/2

func _process(delta: float):
	time += delta*0.1
	time = wrapf(time, 0, 1)
	$ColorRect.color = gradient.sample(time)

@onready var slap_cooldown = get_parent().get_node("SlapCooldown")

var last_slap_was_with = null
func _integrate_forces(state):
	if(!is_instance_valid(slap_cooldown) or !slap_cooldown.is_stopped()):
		return
	for i in state.get_contact_count():
		if(last_slap_was_with != state.get_contact_collider_id(i) &&
				state.get_contact_impulse(i).length()/
				(state.step*max_contacts_reported) > 40):
			$SlapPlayer.play()
			slap_cooldown.start()
			last_slap_was_with = state.get_contact_collider_id(i)
