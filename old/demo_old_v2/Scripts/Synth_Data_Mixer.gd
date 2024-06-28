
extends Synth_Data
class_name Synth_Data_Mixer

var bus_vol : float
@export var quiet := false :
	set(value):
		quiet = value
		if quiet:
			bus_vol -= 20.0
			AudioServer.set_bus_volume_db(bus_idx, bus_vol)
			print(AudioServer.get_bus_volume_db(bus_idx), get_bus(), bus_idx, AudioServer.get_bus_send(bus_idx))
		else:
			bus_vol = 0.0
			AudioServer.set_bus_volume_db(bus_idx, bus_vol)
			print(get_bus(), bus_idx, AudioServer.get_bus_send(bus_idx))

func _ready() -> void:
	
	#AudioServer.set_bus_name(bus_idx, get_name())
	#set_bus(get_name())
	#AudioServer.set_bus_mute(bus_idx, false)

	
	#print(get_bus(), " bus created at idx ", bus_idx, ":", AudioServer.get_bus_index(get_name()))
	wire_connected.connect(self._on_wire_connected)
	wire_disconnected.connect(self._on_wire_disconnected)
	#bus_vol = AudioServer.get_bus_volume_db(bus_idx)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		quiet = !quiet
func _on_wire_connected(_data: Synth_Data) -> void:
	print("Data: ", _data.get_name())
	print("MBus: ", _data.get_bus(), " i: ", _data.bus_idx, " sends: ", AudioServer.get_bus_send(_data.bus_idx)," muted:", AudioServer.is_bus_mute(_data.bus_idx))
	print("M: ", get_name())	
	print("MBus: ", get_bus(), " i: ", bus_idx, " sends: ", AudioServer.get_bus_send(bus_idx)," muted:", AudioServer.is_bus_mute(bus_idx))
	
	AudioServer.set_bus_send(_data.bus_idx,get_bus())
	
	AudioServer.set_bus_mute(_data.bus_idx, false)
	AudioServer.set_bus_mute(bus_idx,true)
	print("Data: ", _data.get_name())
	print("DBus: ", _data.get_bus(), " i: ", _data.bus_idx, " sends: ", AudioServer.get_bus_send(_data.bus_idx), " muted:", AudioServer.is_bus_mute(_data.bus_idx))
	print("M: ", get_name())	
	print("MBus: ", get_bus(), " i: ", bus_idx, " sends: ", AudioServer.get_bus_send(bus_idx), " muted:", AudioServer.is_bus_mute(bus_idx))

func _on_wire_disconnected(_data : Synth_Data) -> void:
	#_data.set_bus(_data.get_name())
	AudioServer.set_bus_mute(bus_idx,true)
	AudioServer.set_bus_mute(_data.bus_idx, true)
	AudioServer.set_bus_send(_data.bus_idx, _data.get_bus())
	print(AudioServer.get_bus_send(_data.bus_idx)," send1:send2 " ,AudioServer.get_bus_send(bus_idx))
	#print(get_name(), " disconnected from ", _data.get_name(), " @bus:", _data.get_bus())

func _on_mixer_level(value: float)->void:
	#print(AudioServer.get_bus_volume_db(bus_idx))
	var v : float = lerpf(-80, 0.0, value)
	AudioServer.set_bus_volume_db(bus_idx, v)
	#print(AudioServer.get_bus_name(bus_idx), " bus idx: ", bus_idx, "vol: ", AudioServer.get_bus_volume_db(bus_idx))

func _on_master_level(value: float)->void:
	var v : float = lerpf(-80, 0.0, value)
	AudioServer.set_bus_volume_db(0, v)
	#print(AudioServer.get_bus_name(0), " bus idx: ", bus_idx, "vol: ", AudioServer.get_bus_volume_db(0))
