extends Node

## does the heavy lifting for audio sliders
## use as a singleton

## set bus volume between 0.0-1.0
func set_bus_volume(bus:String, volume:float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear_to_db(volume))

func save_bus_volume(bus:String, volume:float):
	var audio_volume = Saver.get_value("audio_volume")
	if(audio_volume == null):
		audio_volume = {}
	audio_volume[bus] = volume
	Saver.set_value("audio_volume", audio_volume)

func get_bus_volume(bus:String) -> float:
	var audio_volume = Saver.get_value("audio_volume")
	if(audio_volume == null):
		audio_volume = {}
	if(not audio_volume.has(bus)):
		return 0.5
	return audio_volume[bus]

func load_volumes():
	var audio_volume = Saver.get_value("audio_volume")
	if(audio_volume == null):
		audio_volume = {}
	for bus in audio_volume:
		set_bus_volume(bus, audio_volume[bus])

func _ready():
	load_volumes()
