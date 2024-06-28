extends Synth_Data

class_name Synth_Data_IN

signal send_cv(value: float)
signal connect_audio_to_out(_audio_player: Synth_Data)
signal disconnect_audio_from_out()

var sending_cv := false

func _ready()->void:
	super()

func _process(delta: float) -> void:
	if sending_cv:
		var send_voltage :float = 0.0
		for w in wires:
			send_voltage += w.voltage
		send_cv.emit(send_voltage)

	
		

func _on_wire_connected(_data: Synth_Data) -> void:
	super(_data)
	sending_cv = true


func _on_all_wires_disconnected()->void:
	#print(get_name(),wires, "no wires")
	super()
	sending_cv = false
	send_cv.emit(0.0)
	
	
