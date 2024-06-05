extends Synth_Data

class_name Synth_Data_CVIN

signal send_cv(value: float)
var sending := false

func _ready()->void:
	wire_connected.connect(self._on_wire_connected)
	wire_disconnected.connect(self._on_wire_disconnected)
	AudioServer.set_bus_name(bus_idx, get_name())
	AudioServer.add_bus_effect(bus_idx, AudioEffectCapture.new(), 0)
	set_bus(get_name())
	print(get_bus(), " bus created at idx ", bus_idx, ":", AudioServer.get_bus_index(get_name()))
	#print (get_name(), "ready")

func _process(delta: float) -> void:
	if sending:
		send_cv.emit(connected_to.voltage)
		

func _on_wire_connected(_data: Synth_Data) -> void:
	sending = true
	_data.set_bus(get_name())
	AudioServer.set_bus_mute(bus_idx,false)
	AudioServer.set_bus_effect_enabled(bus_idx, 0, true)
	print(get_name(), " sending from" , connected_to.get_name() )

func _on_wire_disconnected(_data: Synth_Data) -> void:
	sending = false
	_data.set_bus(_data.get_name())
	AudioServer.set_bus_mute(bus_idx,true)
	AudioServer.set_bus_effect_enabled(bus_idx, 0, false)
	print(get_name(), " stopped sending_from" , connected_to.get_name() )
