@tool
extends AudioStreamPlayer3D
#remember 3D needs camera!!!
class_name Gynth_3D_GD
@export var bang := false : set = receive_bang
func receive_bang(value:bool)->void:
		if get_stream_paused():
			set_stream_paused(false)
var playback : AudioStreamPlayback
var time := 0.0
var voltage : float = 0.0
var frequency := 440.0
var mix_rate := 48000.0
var phase := 0.0
var buffer :PackedFloat32Array = []
var buffer_limit : int = 0
var draw_buffer :PackedFloat32Array = []
var attenuation : float = 1 :
	set(value):
		attenuation = 1.0 - value/10
var env_limiter : float = 0
var prev_voltage : float = 0.0
var bus_idx: int 
var bus_name: StringName


@export_category("OSC")
enum {SIN,SAW, PULSE, SQUARE}
@export_enum("SIN", "SAW", "PULSE", "SQUARE") var osc_type :int = SIN

@export_range(0, 10, 0.001) var pitch: float = 0.99 :
	set(value):
		pitch = value
		set_pitch_scale(pitch+0.01)
		buffer_limit = mix_rate
		#buffer_limit = frequency*pitch_scale*2
		#if buffer_limit < 440:
			#buffer_limit = 440
		#buffer_limit = 200

@export var generating := false : set = set_generating
func set_generating(value: bool)->void:
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
@export var env_enabled:= true : set = set_env_enabled
func set_env_enabled(_v: bool)->void:
	env_enabled = _v
	if not env_enabled:
		env_limiter = 0.0
		
@export var loop := true 

@export_range(0, 10, 0.001) var speed: float = 1.0 : 
	set(value):
		speed = value
		#init_envelope()
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
	tree_exiting.connect(_on_tree_exiting)

func _ready() -> void:
	init_bus()
	init_envelope()
	pitch=pitch
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		buffer_limit += 1
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
				env_limiter = envelope.sample(time*(1/speed))
				volume_db = (linear_to_db(env_limiter*attenuation))
				
		else: 
			volume_db = linear_to_db(attenuation)
				
				#print(attenuation)
	if playing:
		time += delta
			
	
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
	if buffer.size()<= buffer_limit:
		buffer.append(voltage)
	else:
		draw_buffer = buffer
		buffer = []
	playback.push_frame(Vector2(voltage, voltage))


func set_f(_pitch: float)-> void:
	var p_scale : float = _pitch/frequency
	set_pitch_scale(p_scale)
