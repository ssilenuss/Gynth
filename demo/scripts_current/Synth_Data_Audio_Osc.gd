extends Synth_Data
class_name Synth_Data_Audio_Osc

var audio_osc = Audio_Oscillator_GD.new()
var freq_pot_value : float
var input_voltage : float

func _ready()->void:
	
	#audio_player = audio_osc
	#audio_osc = Audio_Oscillator_GD.new()
	input_voltage = 0.0
	audio_players.append(audio_osc)
	add_child(audio_osc)
	audio_osc.frequency = 110.0
	super()

func _process(delta: float) -> void:
	super(delta)
	if audio_osc.generating:
		voltage = audio_osc.value
		


func _on_wire_connected(_data: Synth_Data) -> void:
	super(_data)
	audio_osc.generating = true

	#print(get_name(), " generating: ", audio_osc.generating)
	
func _on_all_wires_disconnected() -> void:
	super()
	audio_osc.generating = false
	#print(audio_osc.generating)

func _on_pot_value_changed(value: float)->void:
	freq_pot_value = value
	#voltage = freq_pot_value + input_voltage
	
	#print("voltage: ", voltage, " input_voltage: ", input_voltage, "pot_val", freq_pot_value)
	mod_frequency()

func _on_update_voltage(value: float)->void:
	#don't! super(value)
	input_voltage = value
	voltage = input_voltage + freq_pot_value
	mod_frequency()

	
func mod_frequency()->void:
	var p = pow(2, ((10*freq_pot_value)+input_voltage))
	#print(input_voltage,", ", voltage)
	audio_osc.set_pitch_scale(p)
