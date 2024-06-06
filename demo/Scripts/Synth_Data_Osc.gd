extends Synth_Data
class_name Synth_Data_Osc

enum {SIN,SAW, PULSE, SQUARE}
@export_enum("SIN", "SAW", "PULSE", "SQUARE") var osc_type :int
@export var frequency := 110.0
var mix_rate : float = 48000.0
var playback = AudioStreamGeneratorPlayback
var effective_frequency : float
var pot_val:float

	
var generating := false :
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

func _ready()->void:
	wire_connected.connect(self._on_wire_connected)
	wire_disconnected.connect(self._on_wire_disconnected)
	AudioServer.set_bus_name(bus_idx, get_name())
	set_bus(get_name())
	print(get_bus(), " bus created at idx ", bus_idx, ":", AudioServer.get_bus_index(get_name()))
		
func _process(delta: float) -> void:
	if generating:
		fill_buffer()

		
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


func modify_frequency(value:float)->void:
	#value should be 0.0-1.0
	#var p :float = lerpf(1.0, 11.0, value)
	#var p : float = Singleton.logerp(1.0, 64.0, value)
	var p = pow(2, (10*(value+pot_val)))
	set_pitch_scale(p)
	effective_frequency = pitch_scale*frequency
	


func modify_amplitude(value:float)->void:
	#value should be 0.0-1.0
	pass


func _on_wire_connected(_data: Synth_Data) -> void:
	generating = true
	print(get_name(), " connecte to" , connected_to.get_name(),"  Generating: ", generating)

func _on_wire_disconnected(_data: Synth_Data) -> void:
	generating = false
	print(get_name(), " disconnected_from" , connected_to.get_name(),"  Generating: ", generating)




func _on_cv_in(value: float) -> void:
	modify_frequency(value*0.1)


func _on_potentiometer_value_changed(value: float) -> void:
	pot_val = value
	modify_frequency(0.0)

