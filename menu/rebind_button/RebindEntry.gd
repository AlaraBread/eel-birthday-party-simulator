extends ColorRect

## the action to be rebound
@export var action:String :
	set(new):
		action = new
		if(not is_inside_tree()):
			await ready
		keyboard_button.action = action
		keyboard_button.update_text()
## the display name of the action
@export var text:String :
	set(new):
		if(not is_inside_tree()):
			await ready
		text = new
		%Label.text = text

## whether the keyboard should have a rebind button
@export var keyboard:bool = true
## whether the controller should have a rebind button
@export var controller:bool = false

@onready var keyboard_button:Button = %KeyboardButton

func _ready():
	if(not keyboard):
		keyboard_button.queue_free()
