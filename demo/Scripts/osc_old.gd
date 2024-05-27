@tool
extends AudioStreamPlayer2D

var osc : Osc = Osc.new()


@export var test : bool = false:
	set(value):
		test = false
		osc.set_playback(get_stream_playback())
		osc.fill_buffer()
		print (osc.get_playback())
@export var play_osc : bool = false :
	set(value):
		if value:
			if !is_playing():
				play()
			osc.set_playback(get_stream_playback())
			osc.fill_buffer()
		else:
			stop()
		play_osc = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_stream(osc)
	play_osc = false

func _process(delta: float) -> void:
	if play_osc:
		osc.fill_buffer()
