extends Synth_Data
class_name Synth_Data_VCA

var pot_val : float

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

func _on_pot_changed(value: float)->void:
	pot_val = value
	modify_amplitude()

func _on_cv_changed(value:float)->void:
	voltage=value
	modify_amplitude()

func modify_amplitude()->void:
	var v : float = lerpf(-80, 0.0, voltage+pot_val)
	AudioServer.set_bus_volume_db(bus_idx, v)
	print(AudioServer.get_bus_name(bus_idx), " bus idx: ", bus_idx, "vol: ", AudioServer.get_bus_volume_db(bus_idx))
