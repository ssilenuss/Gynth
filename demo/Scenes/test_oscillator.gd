
extends  Synth_Data
class_name test_osc


enum {SIN,SAW, PULSE, SQUARE}
@export_enum("SIN", "SAW", "PULSE", "SQUARE") var osc_type :int
@export var frequency := 110.0
var mix_rate : float = 48000.0
var playback = AudioStreamGeneratorPlayback
var effective_frequency : float
var pot_val:float



var bus_vol := 0.0
	
@export var generating := false :
	set(value):
		generating = value
		if generating:
			stream = AudioStreamGenerator.new()
			stream.mix_rate = mix_rate
			play()
			playback = get_stream_playback()
			fill_buffer()

		else:
			stop()
		


func _process(delta: float) -> void:
	if generating:
		fill_buffer()
	if Input.is_action_just_pressed("ui_left"):
		generating = !generating
	#print(get_bus(), AudioServer.get_bus_name(bus_idx), AudioServer.get_bus_volume_db(bus_idx))


		
func fill_buffer():
	var increment := frequency / mix_rate
	var to_fill: int = playback.get_frames_available()
	
	match osc_type:
		SIN:
			while to_fill > 0:
				playback.push_frame(Vector2.ONE * sin(voltage * TAU))
				voltage = fmod(voltage + increment, 1.0)
				to_fill -= 1

		SAW:
			while to_fill > 0:
				voltage = fmod(voltage + increment, 1.0)
				playback.push_frame(Vector2.ONE*voltage)
				to_fill -= 1

		PULSE:
			while to_fill > 0:
				voltage = fmod(voltage + increment, 1.0)
				playback.push_frame(Vector2.ONE*(1.0 -voltage))
				to_fill -= 1

		SQUARE:
			while to_fill > 0:
				voltage = fmod(voltage + increment, 1.0)
				if voltage<=0.5:
					playback.push_frame(Vector2.ONE)
				else:
					playback.push_frame(Vector2.ZERO)
				to_fill -= 1
