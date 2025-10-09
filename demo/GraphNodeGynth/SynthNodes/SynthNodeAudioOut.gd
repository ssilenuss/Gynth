extends SynthNode
class_name SynthNodeAudioOut

var audiobus_name : String
var audiobus_idx : int
var output_bus_name : String
var output_bus_idx : int = 0

func _ready() -> void:
	super()
	
	spawn_audio_bus()
	
	#Audio input
	set_slot(0, true, types.AUDIO,Color.BLUE,false, types.AUDIO, Color.BLUE)

func spawn_audio_bus()->void:
	AudioServer.add_bus()
	var count: int = AudioServer.get_bus_count()
	audiobus_idx = count-1
	audiobus_name = AudioServer.get_bus_name(audiobus_idx)
	
	output_bus_name = AudioServer.get_bus_name(output_bus_idx)
	AudioServer.set_bus_send(audiobus_idx, output_bus_name)
	
	print(audiobus_idx,", ", audiobus_name)
	print("Audio Bus Count: ", AudioServer.get_bus_count())
	
func _on_delete_request() -> void:
	AudioServer.remove_bus(audiobus_idx)
	print("Audio Bus Count: ", AudioServer.get_bus_count())
	super()
