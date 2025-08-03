extends Button
class_name RebindButton

## this button allows the user to rebind controls
## relies on the InputHelper and Saver singletons

## name of the action to be rebound
@export var action:String
## index in the input map for the binding
@export var rebind_index:int = -1

enum InputMode {ALL, KEYBOARD, CONTROLLER}
@export var input_mode:InputMode = InputMode.ALL

enum {NORMAL, PRESSED}

var state:int:
	set(new):
		match new:
			NORMAL:
				disabled = false
				text = InputHelper.get_action_binding_as_text(action, rebind_index)
			PRESSED:
				disabled = true
				text = "Press any key..."
		state = new

func _enter_tree():
	InputHelper.reset_binds.connect(on_reset_binds)

func on_reset_binds():
	update_text()

func update_text():
	self.state = state

func _on_button_pressed():
	if(state == NORMAL):
		self.state = PRESSED

func _on_button_focus_exited():
	if(state == PRESSED):
		self.state = NORMAL

func _input(event:InputEvent):
	if(event is InputEventMouseMotion):
		return
	if(event is InputEventJoypadButton or event is InputEventJoypadMotion):
		if(input_mode == InputMode.KEYBOARD):
			return
	if(event is InputEventMouse or event is InputEventKey):
		if(input_mode == InputMode.CONTROLLER):
			return
	if(event is InputEventJoypadMotion and abs(event.axis_value) < 0.5):
		return
	if((event is InputEventKey or event is InputEventMouseButton) and event.pressed):
		return
	if(state == PRESSED):
		InputHelper.rebind_action(action, event, rebind_index)
		InputHelper.save_rebind(action, event, rebind_index)
		self.state = NORMAL
