
extends AudioStreamPlayer

class_name Synth_Audio_Player

var synth_data : Synth_Data
var bus_idx : int
		
var generating := false :
	set(value):
		generating = value
		if generating:
			stream = AudioStreamGenerator.new()
			stream.mix_rate = mix_rate
			play()
			playback = get_stream_playback()
			#_fill_buffer()
		else:
			stop()


var mix_rate := 22050.0
var playback: AudioStreamPlayback



func _process(_delta: float) -> void:

	if generating:
		if synth_data:
			synth_data.fill_buffer(playback,mix_rate)
			synth_data.consume_buffer(playback)

func _ready() -> void:
	bus_idx = AudioServer.get_bus_index(get_bus())

func _on_wire_connected(_data: Synth_Data) -> void:
	synth_data = _data
	generating = true
	synth_data.connected = true
	print(get_name(), " reports " ,_data, " connected")

func _on_wire_disconnected() -> void:
	synth_data.connected = false
	synth_data = null
	generating = false


func _on_potentiometer_value_changed(value: float) -> void:
	var volume: float = lerpf(-80, 0, value)
	AudioServer.set_bus_volume_db(bus_idx, volume)
	
