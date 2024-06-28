
extends Synth_Data
var bus_vol : float = 0.0
var bus_idx : int
@export var data : Synth_Data

func _ready() -> void:

	super._ready()
	bus_idx = AudioServer.get_bus_index(get_name())
	bus_vol = AudioServer.get_bus_volume_db(bus_idx)
	
		
func _on_wire_connected(_data: Synth_Data) -> void:
	
	if _data.audio_audio_player:
		_data.audio_player.set_bus(get_name())
func _on_wire_disconnected(_data : Synth_Data) -> void:
	_data.set_bus("Mute")
	
func _on_mixer_level(value: float)->void:

	var v : float = lerpf(-80, 0.0, value)
	AudioServer.set_bus_volume_db(bus_idx, v)
	#print(AudioServer.get_bus_name(bus_idx), " bus idx: ", bus_idx, "vol: ", AudioServer.get_bus_volume_db(bus_idx))

func _on_master_level(value: float)->void:
	var v : float = lerpf(-80, 0.0, value)
	AudioServer.set_bus_volume_db(0, v)
	#print(AudioServer.get_bus_name(0), " bus idx: ", bus_idx, "vol: ", AudioServer.get_bus_volume_db(0))
