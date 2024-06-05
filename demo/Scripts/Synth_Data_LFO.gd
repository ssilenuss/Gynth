extends Synth_Data
class_name Synth_Data_LFO

enum {SIN,SAW, PULSE, SQUARE}
@export_enum("SIN", "SAW", "PULSE", "SQUARE") var osc_type :int
@export var frequency := 1.0

var phase := 0.0
	
var generating := false :
	set(value):
		generating = value

func _ready()->void:
	wire_connected.connect(self._on_wire_connected)
	wire_disconnected.connect(self._on_wire_disconnected)
	
		
func _process(delta: float) -> void:
	if generating:
		oscillate_voltage(delta)
		
func oscillate_voltage(delta:float):
	#increment = 1 second / frequency 
	var increment := 1.0/frequency * delta
	
	match osc_type:
		SIN:
			voltage = sin(phase * TAU)/2 + 0.5
			phase = fmod(phase + increment, 1.0)
			
		SAW:
			voltage = fmod(phase + increment, 1.0)
			
		PULSE:
			phase = fmod(voltage + increment, 1.0)
			voltage = 1.0 -voltage
	
		SQUARE:
			phase = fmod(voltage + increment, 1.0)
			if phase<=0.5:
				voltage = 1.0
			else:
				voltage = 0.0



func _on_modify_frequency(value:float)->void:
	#value should be 0.0-1.0
	#(how many seconds for a wave.  0.001 = 1000x a second
	frequency = lerpf(10, 0.01, value)



func _on_modify_amplitude(value:float)->void:
	#value should be 0.0-1.0
	pass


func _on_wire_connected(_data: Synth_Data) -> void:
	generating = true
	print(get_name(), " connecte to" , connected_to.get_name(),"  Generating: ", generating)

func _on_wire_disconnected(_data: Synth_Data) -> void:
	generating = false
	print(get_name(), " disconnected_from" , connected_to.get_name(),"  Generating: ", generating)




func _on_cv_in(value: float) -> void:
	_on_modify_frequency(value)
	#print(value)
	pass # Replace with function body.


func _on_potentiometer_value_changed(value: float) -> void:
	pass # Replace with function body.
