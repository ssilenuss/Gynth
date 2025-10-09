extends SynthNode
class_name SynthNodeFrequencySlider


var value : float
var title_text : String = "Frequency: "


func _ready()->void:
	super()
	title = title_text
	#must add at aleast one control
	var sb := SpinBox.new()
	add_child(sb)
	sb.custom_minimum_size = Vector2(50,50)
	sb.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	sb.min_value = 0.1
	sb.max_value = 10.0
	sb.step = 0.001
	sb.editable = true
	sb.value = 5

	sb.value_changed.connect(_on_slider_value_changed)
	
	
	set_slot(0, false, types.FLOAT,Color.MAGENTA,true, types.FLOAT, Color.MAGENTA)
	
	#set frequency input
func _on_slider_value_changed(_value: float)->void:
	value = _value
	
	
