extends Synth_Data

class_name Synth_Data_CVOUT

@export var gate := false

func _ready()->void:
	wire_connected.connect(self._on_wire_connected)
	wire_disconnected.connect(self._on_wire_disconnected)
	#AudioServer.set_bus_name(bus_idx, get_name())
	#AudioServer.add_bus_effect(bus_idx, AudioEffectCapture.new(), 0)
	#set_bus(get_name())
	#print(get_bus(), " bus created at idx ", bus_idx, ":", AudioServer.get_bus_index(get_name()))
	#print (get_name(), "ready")

func _process(delta: float) -> void:
	pass
	
		

func _on_wire_connected(_data: Synth_Data) -> void:
	pass

func _on_wire_disconnected(_data: Synth_Data) -> void:
	pass

func _on_modify_voltage(value: float)->void:
	if gate:
		if value==0.0:
			voltage = 0.0
		else:
			voltage = 1.0
	else:
		voltage = value
