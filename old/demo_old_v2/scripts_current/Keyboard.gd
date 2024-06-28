extends Control

func _ready()->void:
	for p in get_tree().get_nodes_in_group("piano_key"):
		var k : Piano_Key = p
		k.pitch_output = $VBoxContainer/Sockets/PitchOut/Output/Synth_Data_OUT
		k.gate_output = $VBoxContainer/Sockets/Gate/Output/Synth_Data_OUT
		if k.pitch_output:
			k.piano_key_pitch.connect(k.pitch_output._on_update_voltage)
		if k.gate_output:
			k.piano_key_gate.connect(k.gate_output._on_update_voltage)
