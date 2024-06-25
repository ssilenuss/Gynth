extends Synth_Data

class_name Synth_Data_Envelope


var time: float 

var lfo : LFO_GD
var attack : float
var decay_release : float
var sustain: float 
var gate_value : float 

signal gate_high
signal gate_low

var can_bang := false

enum states {ATTACK, DECAY, SUSTAIN, RELEASE, OFF = -1 }
var state : int = states.OFF



var generating_envelope := false :
	set(value):
		generating_envelope = value
		
		
var looping:= false :
	set(value):
		looping = value
		#if looping:
			#generating = true
		#else:
			#if gate_socket.wires.size() <= 0:
				#generating = false
			#
#



@export var gate_socket:Synth_Data

func _ready()->void:
	
	#lfo.frequency = 1.0
	#lfo.osc_type = LFO_GD.SQUARE
	#lfo.generating = true
	add_child(lfo)
	#lfo.gate_high.connect(_on_gate_high)
	#lfo.gate_low.connect(_on_gate_low)
	gate_high.connect(_on_gate_high)
	gate_low.connect(_on_gate_low)

func _process(delta: float) -> void:
	super(delta)
	if looping:
		pass
	elif gate_socket:
		if gate_socket.wires.size()>0:
			gate_value = gate_socket.voltage
		#else:
			##gate_value = 1.0
	if generating_envelope:
		generate_envelope(delta)


func generate_envelope(delta: float)->void:
	time += delta
	if state == states.ATTACK:
		voltage =1.0-  pow(attack, time*10)
		if voltage >= 0.99:
			state = states.DECAY
			time = 0.0
		#print(attack, "   attack")

	elif state == states.DECAY:

		#lp.y = cp_decay_end.y - Singleton.logerp( cp_decay_end.y+1.0, 1.0, t)-1.0
		voltage =pow(decay_release, time*10)
		voltage = lerpf(sustain, 1.0, voltage)
		#print(voltage, "   decay")
	elif state == states.RELEASE:
		var curr_v:float = voltage
		voltage =pow(decay_release, time)
		voltage = lerpf(0.0, curr_v, voltage)

		if voltage <= 0.001:
			state = states.OFF
			
	
	send_cv.emit(voltage)

	clamp(voltage,0.0,1.0)
	
func _on_wire_connected(_data: Synth_Data) -> void:
	super(_data)
	#generating_envelope = true

func _on_all_wires_disconnected() -> void:
	super()
	#generating_envelope = false
	#print(audio_osc.generating)

func _on_decay_release_value_changed(value: float)->void:
	decay_release = clampf(value, 0.001, 0.999)
	#dr = decay_release*decay_release
func _on_sustain_value_changed(value: float)->void:
	sustain = clampf(value, 0.001, 0.999)
	

func _on_loop_toggled(toggled_on: bool) -> void:
	looping = toggled_on

func _on_gate_high()->void:
	generating_envelope = true
	state = states.ATTACK
	voltage = 0.0
	time = 0.0
	#send_cv.emit(-1.0)
	send_cv.emit(voltage)
	
	
func _on_gate_low()->void:
	state = states.RELEASE
	time= 0.0
	
func _on_attack_changed(value: float) -> void:
	attack = clampf(value, 0.001, 0.999)
	
func _on_update_voltage(value: float)->void:
	
	if value >0.5 and can_bang:
		gate_high.emit()
		can_bang = false
	elif value<0.5 and not can_bang:
		gate_low.emit()
		can_bang = true
