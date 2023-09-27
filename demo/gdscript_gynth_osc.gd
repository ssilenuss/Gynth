@tool
extends AudioStreamPlayer3D

var sample_hz := 48000
var pulse_hz = 440.0*.5
var phase = 0.0

var playback: AudioStreamPlayback = null # Actual playback stream, assigned in _ready().

func _fill_buffer():
	var increment = pulse_hz / sample_hz

	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		playback.push_frame(Vector2.ONE * sin(phase * TAU)) # Audio frames are stereo.
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1


func _process(_delta):
	_fill_buffer()


func _ready():
	var gen := AudioStreamGenerator.new()
	set_stream(gen)
	# Setting mix rate is only possible before play().
	stream.mix_rate = sample_hz
	play()
	playback = get_stream_playback()
	# `_fill_buffer` must be called *after* setting `playback`,
	# as `fill_buffer` uses the `playback` member variable.
	_fill_buffer()
