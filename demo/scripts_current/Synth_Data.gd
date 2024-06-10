extends Node
class_name Synth_Data


signal wire_connected(_data:Synth_Data)
signal wire_disconnected(_data:Synth_Data)
signal all_wires_disconnected()
signal send_cv(value: float)
signal send_audio_players(value: Array)

var voltage : float = 0.0
@export var gate := false
@export var cv_only:=true
var sending_cv := false

#var audio_player : AudioStreamPlayer
var audio_players : Array = []

#array of Synth_Data
var wires :Array= [] 



func _ready()->void:
	wire_connected.connect(self._on_wire_connected)
	wire_disconnected.connect(self._on_wire_disconnected)
	all_wires_disconnected.connect(self._on_all_wires_disconnected)
	
func _process(delta: float) -> void:
	voltage =clampf(voltage, 0.0, 11.0)
	#this sends only cv received in an input to an output
	if sending_cv:
		var send_voltage :float = 0.0
		for w in wires:
			send_voltage += w.voltage
		send_cv.emit(send_voltage)
		#print(get_name(), send_voltage)
	
func _on_wire_connected(_data: Synth_Data) -> void:
	if _data.audio_players.size()>0 and not cv_only:
		for i in _data.audio_players.size():
			#var idx :int =audio_players.find(i)
			#if idx == -1: #Audioplayer doesn't yet exist in array
			audio_players.append(_data.audio_players[i])
			print(get_name(), "updated audio players ", audio_players)
	sending_cv = true
	#print(get_name(), " cv-only", cv_only, " sending: ", audio_players)
	send_audio_players.emit(audio_players)
	#print(wires, "wire connected.  audio_players:", audio_players)
	#print(get_name(), " connecte to" , connected_to.get_name(),"  Generating: ", generating)

func _on_wire_disconnected(_data:Synth_Data) -> void:
	#print(wires, " wire disconnected")
	#print(get_name(), " audioplayers: ", audio_players)
	if audio_players.size()>0 and _data.audio_players.size()>0 and not cv_only:
		for ap in _data.audio_players:
			var idx : int = audio_players.find(ap)
			if idx != -1:
				audio_players.remove_at(idx)
				#print("audioplayer removed")
	send_audio_players.emit(audio_players)
	if wires.size() <= 0:
		all_wires_disconnected.emit()
	
func _on_all_wires_disconnected()->void:
	sending_cv = false
	send_cv.emit(0.0)
	voltage = 0.0
	#print(get_name(),wires, "no wires")
	

func _on_update_voltage(value: float)->void:
	if gate:
		if value==0.0:
			voltage = 0.0
		else:
			voltage = 1.0
	else:
		voltage = value

