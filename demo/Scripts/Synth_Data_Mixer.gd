
extends Synth_Data
class_name Synth_Data_Mixer

func _ready() -> void:
	
	AudioServer.set_bus_name(bus_idx, get_name())
	set_bus(get_name())
	AudioServer.set_bus_mute(bus_idx, false)
	print(get_bus(), " bus created at idx ", bus_idx, ":", AudioServer.get_bus_index(get_name()))
	wire_connected.connect(self._on_wire_connected)
	wire_disconnected.connect(self._on_wire_disconnected)

func _on_wire_connected(_data: Synth_Data) -> void:
	_data.set_bus(get_name())
	AudioServer.set_bus_mute(bus_idx,false)
	print(get_name(), " connected to ", _data.get_name(), " @bus:", _data.get_bus())


func _on_wire_disconnected(_data : Synth_Data) -> void:
	_data.set_bus(_data.get_name())
	AudioServer.set_bus_mute(bus_idx,true)
	print(get_name(), " disconnected from ", _data.get_name(), " @bus:", _data.get_bus())

func _on_mixer_level(value: float)->void:
	var v : float = lerpf(-80, 0.0, value)
	AudioServer.set_bus_volume_db(bus_idx, v)
	print(AudioServer.get_bus_name(bus_idx), " bus idx: ", bus_idx, "vol: ", AudioServer.get_bus_volume_db(bus_idx))

func _on_master_level(value: float)->void:
	var v : float = lerpf(-80, 0.0, value)
	AudioServer.set_bus_volume_db(0, v)
	#print(AudioServer.get_bus_name(0), " bus idx: ", bus_idx, "vol: ", AudioServer.get_bus_volume_db(0))
