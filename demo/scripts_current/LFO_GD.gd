@tool
extends Node
class_name LFO_GD

signal gate_high
signal gate_low

var can_bang := false

var playback : AudioStreamPlayback

enum {SIN,SAW, PULSE, SQUARE, ENV}
@export_enum("SIN", "SAW", "PULSE", "SQUARE", "ENV") var osc_type :int = SIN

@export var frequency := 2.0
var phase := 0.0
var voltage := 0.0
var time := 0.0
var on_time : int = 0

@export var generating := false :
	set(value):
		generating = value
		time = 0.0
		

func _process(delta: float) -> void:
	if generating:
	
		oscillate_voltage(delta)

		
func oscillate_voltage(delta:float):

	match osc_type:
		SIN:
			voltage = sin(phase * TAU)/2 + 0.5
			
			phase = fmod(time*frequency, 1.0)
			
		SAW:
			voltage = fmod(time*frequency, 1.0)
			
			
		PULSE:
			voltage = fmod(time*frequency, 1.0)
			voltage = 1.0 -voltage
	
		SQUARE:
			phase = fmod(time*frequency, 1.0)
			if phase<=0.5:
				voltage = 1.0
				on_time +=1
				if can_bang:
					gate_high.emit()
					can_bang = false
			else:
				voltage = 0.0
				if not can_bang:
					gate_low.emit()
					can_bang = true
				
				
			
	time += delta
	#voltage *= attn_cv
