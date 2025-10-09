extends SynthNode
class_name SynthNodeOsc

#@export var controls_visible_box : CheckBox 
@export var gen_box : CheckBox 
@export var wav_menu : MenuButton 
@export var wav_vis : ColorRect 
@export var frequency_spinbox : SpinBox 
@export var amplitude_spinbox : SpinBox

var wav_menu_popup : PopupMenu
var base_frequency : float


func _ready()->void:
	super()
	
	
	#set frequency input
	
