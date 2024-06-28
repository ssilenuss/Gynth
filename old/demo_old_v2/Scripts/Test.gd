extends Label

@export var test_node: Node 


#func _process(delta: float) -> void:
	#var tn :Synth_Data= test_node
	#var v: float = tn.voltage
	#var ap: AudioStreamPlayer = tn.audio_player
	#var ps : float = ap.pitch_scale
	#var f : float = ap.frequency
	#var ef : float = ap.frequency*ps
	#text = "v: " + str(v) + " ef:" + str(ef) + " ps:" + str(ps)
	#var test_name = test_node.bus_idx
	#var test_idx = AudioServer.get_bus_index(test_node.get_name())
	#var dest_name = AudioServer.get_bus_name(test_idx)
	#var dest_idx = AudioServer.get_bus_index(dest_name)
	#var dest_vol = AudioServer.get_bus_volume_db(dest_idx)
	##var peak_vol = AudioServer.get_bus_peak_volume_left_db(test_idx, 1)
	##text = "NodeName: " + str(test_name)+ " dest name: "+str(dest_name)+ " vol: " +str(peak_vol)
