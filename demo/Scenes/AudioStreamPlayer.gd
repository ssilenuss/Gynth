extends AudioStreamPlayer

class_name gd_osc


# Keep the number of samples per second to mix low, as GDScript is not super fast.
var sample_hz := 22050.0
var pulse_hz := 440.0
var phase := 0.0

# Actual playback stream, assigned in _ready().
var playback: AudioStreamPlayback

func _fill_buffer() -> void:
	var increment := pulse_hz / sample_hz

	var to_fill: int = playback.get_frames_available()
	while to_fill > 0:
		playback.push_frame(Vector2.ONE * sin(phase * TAU)) # Audio frames are stereo.
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1


func _process(_delta: float) -> void:
	_fill_buffer()


func _ready() -> void:
	stream = AudioStreamGenerator.new()

	AudioServer.add_bus()
	AudioServer.set_bus_name(AudioServer.bus_count - 1, get_name())
	set_bus(get_name())
	stream.mix_rate = sample_hz
	play()
	playback = get_stream_playback()

	_fill_buffer()
