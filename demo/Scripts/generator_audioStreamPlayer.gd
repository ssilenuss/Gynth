
extends AudioStreamPlayer

var playback



func _ready():
	# Setting mix rate is only possible before play().

	play()
	
	playback = get_stream_playback()
	print(playback)
	
	stream.playback = get_stream_playback()
	stream.set_generating(true)
	play()
	print(stream.generating)
	print(stream.playback)
	print(stream.frequency)
	stream._fill_buffer()

func _process(delta):

	print(stream.playback.get_playback_position(), stream.frequency)
	stream._fill_buffer()
func _on_frequency_h_slider_value_changed(value):
	%FrequencyLabel.text = "%d Hz" % value
	#pulse_hz = value


func _on_volume_h_slider_value_changed(value):
	# Use `linear_to_db()` to get a volume slider that matches perceptual human hearing.
	%VolumeLabel.text = "%.2f dB" % linear_to_db(value)
	volume_db = linear_to_db(value)
