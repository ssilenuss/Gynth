
extends Synth_Data
class_name Synth_Data_VCA

var input1_voltage : float = 0.0
var input0_voltage : float = 0.0
var pot_value : float = 0.0

func _on_pot_value_changed(value: float)->void:
	pot_value = value
	mod_output()
	#voltage = pot_value + input1_voltage+input0_voltage
	
func _on_input0_voltage(value: float)->void:
	input0_voltage = 1.0
	mod_output()
	#voltage = pot_value + input1_voltage+input0_voltage

func _on_input1_voltage(value: float)->void:
	input0_voltage = value
	mod_output()
	#voltage = pot_value + input1_voltage+input0_voltage

func _on_receive_audio_players(value: Array)->void:
	audio_players = value
	#print(get_name(), audio_players)

func mod_output()->void:
	voltage = (input0_voltage + input1_voltage) * pot_value
	for ap in audio_players:
		(ap as AudioStreamPlayer).set_volume_db(lerpf(-80, 0.0, voltage))
	pass
