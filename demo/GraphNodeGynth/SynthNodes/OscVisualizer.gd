extends ColorRect

class_name OscVisualizer

var gynth :AudioOsc

func _draw()->void:
	var wav_color := Color(0.0, 0.0, 1.0, 1.0)
	#var background_color := Color(0.0, 0.0, 0.0, 1.0)
	if gynth:
		if gynth.generating:
			
			#draw waveform
			var buffer_limit : float = gynth.mix_rate/gynth.frequency*gynth.pitch_scale*4.0#*10.0
			var _draw_waveform : = false
			if gynth.osc_type == gynth.NOISE:
				_draw_waveform = true
			var last_frame :float= 1
			var x_index : int = 0
			
			var gynth_buffer_size :int = gynth.buffer.size()
			
			
			var buffer :PackedVector2Array= []
			for i in gynth_buffer_size:
				if _draw_waveform:
					if buffer.size()<=buffer_limit:
				
						var x : float = lerpf(0.0, size.x, x_index/buffer_limit)
						var y : float = 0
						y = lerpf(size.y-1,1,  ((gynth.buffer[i].x)/2.5)+0.5)
						buffer.append(Vector2(x,y))
						x_index+=1
				else:
				
					if last_frame <= 0.0 and gynth.buffer[i].x>0.0:
						_draw_waveform=true
						last_frame = gynth.buffer[i].x
					else:
						last_frame = gynth.buffer[i].x
			
			
			if buffer.size() > 5:
				draw_polyline(buffer, wav_color)
