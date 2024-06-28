
extends Synth_Data
class_name Synth_Data_Audio_Mixer

var audio_out : AudioStreamPlayer
var bus_vol : float = 0.0
var bus_idx : int
#@export var data : Synth_Data

func _ready() -> void:

	super()
	audio_out = AudioStreamPlayer.new()
	audio_players.append(audio_out)
	add_child(audio_out)
	audio_out.set_bus(get_name())
	bus_idx = AudioServer.get_bus_index(get_name())
	if bus_idx == -1:
		print("WARNING!  Output Mixer set to Master Bus!")
	bus_vol = AudioServer.get_bus_volume_db(bus_idx)

		
func _on_wire_connected(_data: Synth_Data) -> void:
	super(_data)
	#print(get_name(), " audio players: ", audio_players.size()," : ",audio_players)
	if _data.audio_players.size()>0:
		for ap in _data.audio_players:
			ap.set_bus(get_name())
	
		
		
func _on_wire_disconnected(_data : Synth_Data) -> void:
	
	if _data.audio_players.size()>0:
		for ap in _data.audio_players:
			var n : int = audio_players.count(ap)
			#print(ap, " connections here: ", n)
			if n<2:
				ap.set_bus("Mute")
			
			#print(ap, " set to mute")
	super(_data)
	#print(get_name(), " audio players: ", audio_players.size()," : ",audio_players.size())
	#if _data.audio_player:
		#_data.audio_player.set_bus("Mute")

	
func _on_mixer_level(value: float)->void:

	var v : float = lerpf(-80, 0.0, value)
	AudioServer.set_bus_volume_db(bus_idx, v)
	#print(AudioServer.get_bus_name(bus_idx), " bus idx: ", bus_idx, "vol: ", AudioServer.get_bus_volume_db(bus_idx))

func _on_master_level(value: float)->void:
	var v : float = lerpf(-80, 0.0, value)
	AudioServer.set_bus_volume_db(0, v)
	#print(AudioServer.get_bus_name(0), " bus idx: ", bus_idx, "vol: ", AudioServer.get_bus_volume_db(0))
