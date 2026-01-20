extends Control
#https://gdscript.com/solutions/godot-graphnode-and-graphedit-tutorial/
@export var graph : GraphEdit

var selected_node : GraphNode
var initial_pos := Vector2(50,50)
var sn_offset := Vector2(10,10)

func _ready() -> void:
	OS.set_low_processor_usage_mode(true)
	


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("delete"):
		if selected_node:
			selected_node.queue_free()

func _on_synth_node_selected(sn: SynthNode)->void:
	selected_node = sn

func _on_add_node_button_pressed() -> void:
	var sn := SynthNode.new()
	sn.synth_node_selected.connect(_on_synth_node_selected)
	
	graph.add_child(sn)
	sn.position_offset = initial_pos + sn_offset * graph.get_child_count()
	


func _on_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph.connect_node(from_node, from_port, to_node, to_port)


func _on_graph_edit_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph.disconnect_node(from_node, from_port, to_node, to_port)


func _on_graph_edit_visibility_changed() -> void:
	pass # Replace with function body.
