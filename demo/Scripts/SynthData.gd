extends Node
class_name Synth_Data

enum {sin_osc, saw_osc, pulse_osc, square_osc}
@export_enum("sin_osc", "saw_osc", "pulse_osc", "square_osc") var data_type :int= sin_osc

var phase := 0.0
var frequency := 110.0
var frame_buffer : PackedVector2Array = []

var connected := false :
	set(value):
		connected = value
		
func fill_buffer(_playback: AudioStreamGeneratorPlayback, _mixrate:float):
	if not connected:
		print("Can't fill buffer, synth_data not connected")
		return
	var increment := frequency / _mixrate
	var to_fill: int = _playback.get_frames_available()
	frame_buffer = []
	match data_type:
		sin_osc:
			while to_fill > 0:
				frame_buffer.append(Vector2.ONE * sin(phase * TAU))
				phase = fmod(phase + increment, 1.0)
				to_fill -= 1
			frame_buffer.reverse()
		saw_osc:
			while to_fill > 0:
				phase = fmod(phase + increment, 1.0)
				frame_buffer.append(Vector2.ONE*phase)
				to_fill -= 1
			frame_buffer.reverse()
		pulse_osc:
			while to_fill > 0:
				phase = fmod(phase + increment, 1.0)
				frame_buffer.append(Vector2.ONE*(1.0 -phase))
				to_fill -= 1
			frame_buffer.reverse()
		square_osc:
			while to_fill > 0:
				phase = fmod(phase + increment, 1.0)
				if phase<=0.5:
					frame_buffer.append(Vector2.ONE)
				else:
					frame_buffer.append(Vector2.ZERO)
				to_fill -= 1
			frame_buffer.reverse()

func consume_buffer(_playback: AudioStreamGeneratorPlayback)->void:
	for f in frame_buffer.size():
		_playback.push_frame(frame_buffer[f])
	frame_buffer = []


func _on_potentiometer_value_changed(value: float) -> void:
	pass # Replace with function body.
