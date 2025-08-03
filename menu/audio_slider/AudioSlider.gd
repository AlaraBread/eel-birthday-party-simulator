@tool
extends ColorRect

## name of the audio bus we want this slider to control
@export var bus_name:String = "Master"
## text to be displayed next to slider
@export var text:String = "Master Volume" :
	set(new):
		text = new
		%Label.text = text

func _ready():
	if(Engine.is_editor_hint()):
		return
	%Slider.value = AudioHelper.get_bus_volume(bus_name)

func _on_slider_value_changed(value:float):
	AudioHelper.set_bus_volume(bus_name, value)
	AudioHelper.save_bus_volume(bus_name, value)
