@tool
extends AudioStreamPlayer2D
class_name Osc2D
var osc : Osc

@export var test : bool = false :
	set(value):
		test = false

		
@export var play_osc : bool = false:
	set(value):
		if value:
			if !is_playing():
				play()
			osc.set_playback(get_stream_playback())

		else:
			stop()
		play_osc = value
		
@export var frequency: float = 440.0 :
	set(value):
		osc.set_frequency(value)
		frequency = value

@export var mix_rate: float = 48000.0 :
	set(value):
		osc.set_mix_rate(value)

func _init() -> void:
	set_stream(AudioStreamGenerator.new())
	osc = Osc.new()
	osc.set_generator(get_stream())
	osc.set_mix_rate(mix_rate)
	
func _ready() -> void:
	add_child(osc)
	frequency = 110;
	if autoplay:
		play_osc = true


func _on_h_slider_value_changed(value: float) -> void:
	if value >=0:
		pitch_scale = (value)*2.0
	print("value: ", value, "frequency: ", frequency*pitch_scale)
	
