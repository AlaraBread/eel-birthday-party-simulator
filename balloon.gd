class_name Balloon
extends RigidBody2D

signal popped

func _ready():
	if(!is_instance_valid(get_tree())):
		return
	await get_tree().process_frame
	if(!is_instance_valid(get_tree())):
		return
	await get_tree().process_frame
	if(!is_instance_valid(get_tree())):
		return
	for body in $SpawnArea.get_overlapping_bodies():
		if(is_instance_of(body, EelSegment)):
			self.queue_free()
			return
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.play("inflate")
	$AnimatedSprite2D.visible = true
	$SpawnArea.queue_free()
	get_parent().balloon_count += 1

@onready var raycasts = $Raycasts.get_children()

func _integrate_forces(state):
	var total_impulse = Vector2()
	for i in range(state.get_contact_count()):
		total_impulse += state.get_contact_impulse(i)
	var hit_count = 0
	for raycast in raycasts:
		if(raycast.is_colliding()):
			hit_count += 1
	if(total_impulse.length()/(state.step*max_contacts_reported) > 7.0 &&
			hit_count == 5):
		var pop = preload("res://pop.tscn").instantiate()
		pop.position = position
		pop.rotation = rotation
		pop.modulate = $AnimatedSprite2D.modulate
		get_parent().add_child(pop)
		popped.emit()
		queue_free()

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("idle")

var color = Color()
func set_color(c: Color):
	color = c
	$AnimatedSprite2D.modulate = color
