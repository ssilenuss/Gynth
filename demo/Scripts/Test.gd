extends Label

@export var test_node: Node 


func _process(delta: float) -> void:

	text =" LFO1 voltage: " + str(test_node.voltage)
	pass
