extends Synth_Data
class_name Synth_Data_Audio_Osc

var audio_osc := Audio_Oscillator_GD.new()

func _ready()->void:
	super._ready()
	audio_player = audio_osc
	add_child(audio_player)



func _on_wire_connected(_data: Synth_Data) -> void:
	audio_player.generating = true
	print(audio_osc.generating)
	
func _on_wire_disconnected(_data: Synth_Data) -> void:
	audio_player.generating = false
	print(audio_osc.generating)
