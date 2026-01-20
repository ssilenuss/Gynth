extends SynthNode
class_name SynthNodeOsc

#@export var controls_visible_box : CheckBox 
@export var gen_button : CheckButton 
@export var wav_menu : MenuButton 
@export var wav_vis : OscVisualizer
@export var frequency_spinbox : SpinBox 
@export var gynth : AudioOsc

var wav_menu_popup : PopupMenu
var base_frequency : float


func _ready()->void:
	super()
	
	frequency_spinbox.value_changed.connect(_on_frequency_spinbox_changed)
	_on_frequency_spinbox_changed(440.0)
	var freq_slot : int = frequency_spinbox.get_parent().get_index()
	var freq_color := Color.CYAN
	set_slot(freq_slot, true, types.FLOAT, freq_color, true, types.FLOAT, freq_color)
	
	gen_button.toggled.connect(_on_generating_checkbutton_toggled)
	_on_generating_checkbutton_toggled(true)
	var audio_slot : int = wav_vis.get_index()
	var audio_color := Color.BLUE
	set_slot(audio_slot, false, types.AUDIO, audio_color, true, types.AUDIO, audio_color)
	
	wav_menu_popup = wav_menu.get_popup()
	wav_menu_popup.id_pressed.connect(_on_wav_menu_popup_selected)
	_on_wav_menu_popup_selected(0)
	
	wav_vis.gynth = gynth
	
	#set frequency input
	
func _process(_delta: float) -> void:
	if gynth.generating and self.selected:
		wav_vis.queue_redraw()
	
func _on_wav_menu_popup_selected(id)->void:
	wav_menu.text = "WAVE: " + wav_menu_popup.get_item_text(id)
	gynth.osc_type = id
	_on_generating_checkbutton_toggled(false)
	_on_generating_checkbutton_toggled(true)

func _on_generating_checkbutton_toggled(toggled_on: bool) -> void:
	gynth.set_generating(toggled_on)
	gen_button.button_pressed = toggled_on 
	wav_vis.queue_redraw()
	
func _on_frequency_spinbox_changed(value: float) -> void:
	frequency_spinbox.value = value
	gynth.set_effective_frequency(value)
	wav_vis.queue_redraw()
	#gynth.pitch = value-0.01
	
	#base_frequency = gynth.get_effective_frequency()
	#frequency_label.text = str(base_frequency)
