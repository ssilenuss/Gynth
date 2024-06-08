
extends Synth_Data
var bus_vol : float = 0.0
@export var data : Synth_Data
@export var quiet := false :
	set(value):
		quiet = value
		if quiet:
			bus_vol -= 2.0
	
			AudioServer.set_bus_volume_db(bus_idx, bus_vol)
			print(AudioServer.get_bus_volume_db(bus_idx), get_bus(), bus_idx, AudioServer.get_bus_send(bus_idx))
		else:
			bus_vol = 0.0
			AudioServer.set_bus_volume_db(bus_idx, bus_vol)
			print(get_bus(), bus_idx, AudioServer.get_bus_send(bus_idx))
		
@export var connect := false:
	set(value):
		connect = value
		if connect:
			wire_connected.emit(data)
		else:
			wire_disconnected.emit(data)

func _ready() -> void:
	#print(get_bus(), " bus created at idx ", bus_idx, ":", AudioServer.get_bus_index(get_name()))
	wire_connected.connect(self._on_wire_connected)
	wire_disconnected.connect(self._on_wire_disconnected)
	bus_vol = AudioServer.get_bus_volume_db(bus_idx)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		quiet = !quiet
	if Input.is_action_just_pressed("ui_down"):
		connect = !connect
		
func _on_wire_connected(_data: Synth_Data) -> void:
	#_data.set_bus(get_name())
	_data.generating = true
	AudioServer.set_bus_send(_data.bus_idx, get_bus())
	#print("data bus sending to:", AudioServer.get_bus_send(_data.bus_idx))
	#print(_data.get_bus(), get_bus())
	#print(AudioServer.get_bus_name(_data.bus_idx),AudioServer.get_bus_name(bus_idx))
	#print(AudioServer.get_bus_send(_data.bus_idx), AudioServer.get_bus_send(bus_idx))
	AudioServer.set_bus_mute(_data.bus_idx, false)
	AudioServer.set_bus_mute(bus_idx,true)
	#print(AudioServer.is_bus_mute(bus_idx))
	#print(get_name(), " connected to ", _data.get_name(), " @bus:", _data.get_bus())


func _on_wire_disconnected(_data : Synth_Data) -> void:
	#_data.set_bus(_data.get_name())
	_data.generating = false
	AudioServer.set_bus_mute(bus_idx,true)
	AudioServer.set_bus_mute(_data.bus_idx, true)
	AudioServer.set_bus_send(_data.bus_idx, _data.get_bus())
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
