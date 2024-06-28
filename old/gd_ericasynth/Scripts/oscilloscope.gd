extends ColorRect
class_name Oscilloscope

@export var synth_frames : PackedFloat32Array = [] : set = draw_oscilloscope

func draw_oscilloscope(_v:PackedFloat32Array):
	synth_frames = _v
	queue_redraw()


func _draw():
	var point_array : PackedVector2Array = []
	for i in synth_frames.size():
		var point : Vector2
		var inc : float = lerpf(0, size.x, i/synth_frames.size())
		point.x = (float(i)/synth_frames.size())*size.x
		point.y = (synth_frames[i]*size.y/2)+size.y/2
		point_array.append(point)
	draw_polyline(point_array, Color(1,1,1,1),1.0)
