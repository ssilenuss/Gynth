extends Node
class_name Oscillator
#
#var sample_hz = 48000.0 # Keep the number of samples to mix low, GDScript is not super fast.
#var pulse_hz = 440.0
#var phase = 0.0
#
#var playback: AudioStreamPlayback = null # Actual playback stream, assigned in _ready().
#
#var rect : ColorRect
#var width : float 
#var frame_count : int
#var array: PackedVector2Array = []
#var draw_switch := true
#var prev_frame :Vector2
#
#func _fill_buffer():
	#var increment = pulse_hz / sample_hz
#
	#var to_fill = playback.get_frames_available()
	#while to_fill > 0:
		#
		#var frame = Vector2.ONE * sin(phase * TAU)
		#
		#playback.push_frame(frame) # Audio frames are stereo.
		#array.append(frame)
		#
		#if prev_frame.y <0.0 and frame.y >0.0:
			#rect.array = array
			#rect.queue_redraw()
			#array = []
			#
#
		#prev_frame = frame
		#phase = fmod(phase + increment, 1.0)
		#to_fill -= 1
#
#
#func _process(_delta):
	#_fill_buffer()
#
#
#func _ready():
	#rect = $ColorRect
	#width = rect.size.x
	## Setting mix rate is only possible before play().
	#$Player.stream.mix_rate = sample_hz
	#$Player.play()
	#playback = $Player.get_stream_playback()
	## `_fill_buffer` must be called *after* setting `playback`,
	## as `fill_buffer` uses the `playback` member variable.
	#_fill_buffer()
#
#
#func _on_frequency_h_slider_value_changed(value):
	#%FrequencyLabel.text = "%d Hz" % value
	#pulse_hz = value
#
#
#func _on_volume_h_slider_value_changed(value):
	## Use `linear_to_db()` to get a volume slider that matches perceptual human hearing.
	#%VolumeLabel.text = "%.2f dB" % linear_to_db(value)
	#$Player.volume_db = linear_to_db(value)
