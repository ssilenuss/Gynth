@tool
extends AudioStreamPlayer3D
#class_name Gynth_3D_GD
@export var bang := false :
	set(value):
		if get_stream_paused():
			set_stream_paused(false)
var playback : AudioStreamPlayback
var time := 0.0
var voltage : float = 0.0
var frequency := 220.0
var mix_rate := 48000.0
var phase := 0.0
var buffer :PackedFloat32Array = []
var buffer_limit : int = 0
#
#var attack : float = 0.5
#var decay : float = 0.5
#var sustain : float = 0.5
#var release : float = 0.5

var bus_idx: int 
var bus_name: StringName

@export_category("OSC")
enum {SIN,SAW, PULSE, SQUARE, ENV}
@export_enum("SIN", "SAW", "PULSE", "SQUARE", "ENV") var osc_type :int = SIN

@export_range(0, 10, 0.001) var pitch: float = 0.0 :
	set(value):
		pitch = value
		set_pitch_scale(pitch+1.0)

@export var generating := false :
	set(value):
		generating = value
		if generating:
			stream = AudioStreamGenerator.new()
			stream.mix_rate = mix_rate
			play()
			playback = get_stream_playback()
			audio_osc()
		else:
			stop()
@export_category("Envelope")
@export var env_enabled:= true
@export var loop := true 

@export_range(0, 10, 0.001) var speed: float = 1.0 : 
	set(value):
		speed = value
		init_envelope()
@export var envelope := Curve.new()
@export_range(0, 10, 0.001) var attack: float = 0.4 :
	set(value):
		attack = value
		init_envelope()
@export_range(0, 10, 0.001) var decay: float = 0.2 :
	set(value):
		decay = value
		init_envelope()
		
@export_range(0, 10, 0.001) var sustain: float = 0.5 :
	set(value):
		sustain = value
		init_envelope()
		
@export_range(0, 10, 0.001) var release: float = 0.1 :
	set(value):
		release = value
		init_envelope()



func _init() -> void:
	tree_entered.connect(_on_tree_entered)
	tree_exiting.connect(_on_tree_exiting)

func _ready() -> void:
	init_bus()
	init_envelope()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if generating:
		audio_osc()
		if env_enabled:
			if time>speed:
				if loop:
					time = 0.0
				elif playing:
					stream_paused = true
					time = 0.0
			else:
				var attenuation : float = envelope.sample(time)
				volume_db = (linear_to_db(attenuation))
				
				#print(attenuation)
	if playing:
		time += delta
			

func _on_tree_entered()->void:
	pass
	
func _on_tree_exiting()->void:
	remove_bus()
	
func init_bus()->void:
	AudioServer.add_bus()
	bus_idx = AudioServer.bus_count-1
	bus_name = "Gynth" + str(bus_idx)
	AudioServer.set_bus_name(bus_idx,bus_name)
	set_bus(bus_name)
	AudioServer.bus_layout_changed.emit()
	#AudioServer.bus_renamed.emit()
	AudioServer.set_bus_send(bus_idx, AudioServer.get_bus_name(0))
	
func init_envelope()->void:
	envelope = Curve.new()
	envelope.add_point(Vector2.ZERO)
	envelope.add_point(Vector2(attack/(attack+decay+release), 1.0))
	envelope.add_point(Vector2((decay+attack)/(attack+decay+release), sustain/10.0))	
	#envelope.add_point(Vector2((decay+attack)/(attack+decay+release), sustain/10.0))
	#envelope.add_point(Vector2(decay+attack/(attack+decay+release)*speed, sustain/10.0))
	envelope.add_point(Vector2(1.0,0.0))
	envelope.bake()
	
func remove_bus()->void:
	AudioServer.remove_bus(bus_idx)
	
func audio_osc()->void:
	var increment := frequency / mix_rate
	var to_fill: int = playback.get_frames_available()
	match osc_type:
		SIN:
			while to_fill > 0:
				voltage = sin(phase * TAU)
				phase = fmod(phase + increment, 1.0)
				push_frame()
				to_fill -= 1
				

		SAW:
			while to_fill > 0:
				phase = fmod(phase + increment, 1.0)
				voltage = lerpf(-1.0,1.0, phase)
				push_frame()
				to_fill -= 1

		PULSE:
			while to_fill > 0:
				phase = fmod(phase + increment, 1.0)
				voltage = lerpf(1.0,-1.0, phase)
				push_frame()
				to_fill -= 1

		SQUARE:
			while to_fill > 0:
				phase = fmod(phase + increment, 1.0)
				if phase<=0.5:
					voltage = -1
				else:
					voltage = 1
				push_frame()
				to_fill -= 1

func push_frame()->void:
	if buffer.size()< buffer_limit:
		buffer.append(voltage)
	playback.push_frame(Vector2(voltage, voltage))

func set_f(_pitch: float)-> void:
	var p_scale : float = _pitch/frequency
	set_pitch_scale(p_scale)
