@tool
extends AudioStreamPlayer
class_name Audio_Oscillator_GD

var value : float = 0.0

var playback : AudioStreamPlayback

enum {SIN,SAW, PULSE, SQUARE, ENV}
@export_enum("SIN", "SAW", "PULSE", "SQUARE", "ENV") var osc_type :int = SIN

var frequency := 440.0
var mix_rate := 48000.0
var phase := 0.0
var buffer :PackedFloat32Array = []
var buffer_limit : int = 0

var attack : float = 0.5
var decay : float = 0.5
var sustain : float = 0.5
var release : float = 0.5

func _ready()->void:
	set_bus("Mute")
	
@export var generating := false :
	set(value):
		generating = value
		if generating:
			stream = AudioStreamGenerator.new()
			stream.mix_rate = mix_rate
			play()
			playback = get_stream_playback()
			print("playback: ", playback)
			#audio_osc()
		else:
			stop()

func _process(delta: float) -> void:
	if generating:
		audio_osc()

		

func audio_osc()->void:
	var increment := frequency / mix_rate
	var to_fill: int = playback.get_frames_available()
	match osc_type:
		SIN:
			while to_fill > 0:
				value = sin(phase * TAU)
				phase = fmod(phase + increment, 1.0)
				push_frame()
				to_fill -= 1
				

		SAW:
			while to_fill > 0:
				phase = fmod(phase + increment, 1.0)
				value = lerpf(-1.0,1.0, phase)
				push_frame()
				to_fill -= 1

		PULSE:
			while to_fill > 0:
				phase = fmod(phase + increment, 1.0)
				value = lerpf(1.0,-1.0, phase)
				push_frame()
				to_fill -= 1

		SQUARE:
			while to_fill > 0:
				phase = fmod(phase + increment, 1.0)
				if phase<=0.5:
					value = -1
				else:
					value = 1
				push_frame()
				to_fill -= 1

func push_frame()->void:
	if buffer.size()< buffer_limit:
		buffer.append(value)
	playback.push_frame(Vector2(value, value))
