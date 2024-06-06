extends Label

@export var test_node: Node 


func _process(delta: float) -> void:

	text =" osc1 effective frequency: " + 	str(test_node.effective_frequency) + 	" pitch_scale: " + str(test_node.get_pitch_scale()) + " pot_val " + str(test_node.pot_val)
	pass
