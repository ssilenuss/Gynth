extends ColorRect

@export var playhead_color: Color = Color(0,0,1,1)
@export var envelope_color: Color = Color(1,1,0,1)
@export var osc_color : Color = Color(0,1,1,1)
@export var attenuation_color:= Color(1,0,1,1)

var gynth : Gynth_3D_GD

var env_points : PackedVector2Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()


func _on_resized() -> void:
	queue_redraw()


		
func _draw() -> void:
	if gynth:
		if gynth.generating:
			var playhead_x : float = lerp(0.0, size.x, gynth.time/gynth.speed)
			draw_line(Vector2(playhead_x, 0.1),Vector2(playhead_x, size.y),playhead_color)
			
			
			var buffer :PackedVector2Array= []
			var buffer_limit = gynth.mix_rate/gynth.frequency*gynth.pitch_scale*10.0
			var draw : = false
			var last_frame :float= 1
			var x_index : int = 0
			for i in gynth.draw_buffer.size():
				if draw:
					if buffer.size()<=buffer_limit:
						var x : float = lerpf(0.0, size.x, x_index/buffer_limit)
						var y : float
						if gynth.env_enabled:
							var a : float = gynth.envelope.sample_baked(x_index/buffer_limit)*gynth.attenuation
							y = lerpf(size.y-1,1,  ((gynth.draw_buffer[i]*a)/2.5)+0.5)
						else:
							y = lerpf(size.y-1,1,  ((gynth.draw_buffer[i]*(gynth.attenuation))/2.5)+0.5)
						buffer.append(Vector2(x,y))
						x_index+=1
				else:
					if last_frame <= 0.0 and gynth.draw_buffer[i]>0.0:
						draw=true
						#print(last_frame, gynth.draw_buffer[i])
						last_frame = gynth.draw_buffer[i]
					#elif last_frame >= 0.0 and gynth.draw_buffer[i]<0.0:
						#draw=true
						##print(last_frame, gynth.draw_buffer[i])
						#last_frame = gynth.draw_buffer[i]
					else:
						last_frame = gynth.draw_buffer[i]
						
			#$Label.text = str(gynth.draw_buffer.size())
			draw_polyline(buffer, osc_color)
			
			#draw envelope
			if gynth.env_enabled:
				var env_pos : Vector2 = Vector2.ZERO
				for i in 100:
					env_pos.y = lerpf(size.y, 0.0, gynth.envelope.sample_baked(i/100.0))
					env_pos.x = lerpf(0.0, size.x, i/100.0)
					env_points.append(env_pos)
				
				draw_polyline(env_points, envelope_color)
				#$Label.text = str(gynth.envelope.sample_baked(50/100))#str(env_points[50])
				env_points = []

			#draw attenuation line
			var y : float = lerpf(size.y,0.0, gynth.attenuation)
			draw_line(Vector2(0.0,y), Vector2(size.x, y),attenuation_color)
			print(gynth.attenuation)
			#for p in env_points:
				
