extends Node
class_name Synth_Data


signal wire_connected(_data:Synth_Data)
signal wire_disconnected(_data:Synth_Data)
signal send_cv(value:float)


var voltage : float = 0.0

var audio:= false :
	set(value):
		audio= value
var audio_player : AudioStreamPlayer

var connected_to :Synth_Data= null :
	set(value):
		if value != null:
			connected_to = value
			wire_connected.emit(value)
		else:
			wire_disconnected.emit(connected_to)
			connected_to = value


func _ready()->void:
	wire_connected.connect(self._on_wire_connected)
	wire_disconnected.connect(self._on_wire_disconnected)
	
func _process(delta: float) -> void:
	if not audio:
		send_cv.emit(voltage)
	
	
func _on_wire_connected(_data: Synth_Data) -> void:
	pass
	#print(get_name(), " connecte to" , connected_to.get_name(),"  Generating: ", generating)

func _on_wire_disconnected(_data: Synth_Data) -> void:
	pass
	
