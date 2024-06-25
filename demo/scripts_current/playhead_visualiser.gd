extends ColorRect

var voltages : PackedFloat32Array = []
var prev_voltages : PackedFloat32Array = []

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_synth_data_envelope_send_cv(value: float) -> void:
	if value <0.001:
		prev_voltages = voltages
	
		voltages = []
		
	else:
		voltages.append(value)
		queue_redraw()

func _draw() -> void:
	var prev_line : PackedVector2Array = []

	for p in prev_voltages.size():
		var pos : Vector2
		pos.x = float(p)/prev_voltages.size()*size.x
		#print(pos.x)
		pos.y = size.y * (1.0 - prev_voltages[p])
		prev_line.append(pos)
	draw_polyline(prev_line, Color(0,1,0,1),1,true)
	
	for p in voltages.size():
		var pos : Vector2 
		if prev_voltages.size()>0:
			pos.x = float(p)/prev_voltages.size()*size.x
		else:
			pos.x = p
		pos.y = size.y * (1.0 - voltages[p])
		draw_circle(pos, 1.0, Color(1.0,0.0,0.0,0.5) )
	
		#draw_circle(pos, 1.0, Color(0.0,1.0,0.0,1.0) )
	#if voltages.size()>0:
		#print(voltages[voltages.size()-1]*size.y)
