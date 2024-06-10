extends Synth_Data

class_name Synth_Data_Envelope

var phase : float = 0.0
var attack : float
var decay_release : float
var sustain: float 
var gate_value : float 
var generating := false
var looping:= false

var time : float = 0.0

var a : float
var dr : float
@export var gate_socket:Synth_Data

func _process(delta: float) -> void:
	super(delta)
	if gate_socket:
		if gate_socket.wires.size()>0:
			gate_value = gate_socket.voltage
		else:
			gate_value = 1.0
	if generating:
		time+=delta
		generate_envelope()

func generate_envelope()->void:
	var a : float = sqrt(time)*attack
	if a <=1:
		voltage = a
	elif voltage>sustain:
		var d = (time-1.0)*(time-1.0) * decay_release
	
	
	
	
func _on_wire_connected(_data: Synth_Data) -> void:
	super(_data)
	generating = true

func _on_all_wires_disconnected() -> void:
	super()
	generating = false
	#print(audio_osc.generating)

func _on_attack_value_changed(value: float)->void:
	attack = value
	#a = sqrt(attack)

func _on_decay_release_value_changed(value: float)->void:
	decay_release = value
	#dr = decay_release*decay_release
func _on_sustain_value_changed(value: float)->void:
	sustain = value
	

func _on_loop_toggled(toggled_on: bool) -> void:
	looping = toggled_on


