extends AudioStreamPlayer
#class_name Synth_Data

signal wire_connected(_data:Synth_Data)
signal wire_disconnected(_data:Synth_Data)
#@export_enum("OSC", "MIXER") var panel_type : int
var connected_to :Synth_Data= null :
	set(value):

		if value != null:
			connected_to = value
			wire_connected.emit(value)
		else:
			wire_disconnected.emit(connected_to)
			connected_to = value
		#print(self, " connected to", connected_to.get_name())
		
			

var bus_idx : int
var voltage : float = 0.0

func _init() -> void:
	AudioServer.add_bus()
	bus_idx = AudioServer.bus_count-1
	var bus_name := AudioServer.get_bus_name(bus_idx)
	set_bus(bus_name)
	AudioServer.set_bus_mute(bus_idx, true)
	AudioServer.set_bus_send(bus_idx, AudioServer.get_bus_name(0))
	#print(bus_idx, bus_name, AudioServer.is_bus_mute(bus_idx))


	
