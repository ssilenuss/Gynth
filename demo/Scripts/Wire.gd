extends Node2D
class_name Wire

@export var segments : int = 3



@onready var end0 :WireEnd = $WireEnd0
@onready var end1 :WireEnd = $WireEnd1
@onready var end :WireEnd = $WireEnd1

var prev_segment: RigidBody2D
var final_pinjoint: PinJoint2D

var can_delete := false

func _ready() -> void:
	end0.wire = self
	prev_segment = $WireSegment
	final_pinjoint = $PinJoint2D4
	
	remove_child(end1)
	for i in segments:
		add_segment()
	end1 = end.duplicate()
	end1.position = final_pinjoint.position
	end1.input = false
	end1.wire = self

	add_child(end1)
	final_pinjoint.set_node_b(end1.get_path())
	end1.held = true
	Singleton.held_wire = end1

	
func _physics_process(delta: float) -> void:
	if can_delete and Input.is_action_just_pressed("left_mouse_button") and Singleton.held_wire == null:
		delete_wire()
		
func delete_wire()->void:
	
	if end1.socket:
		end1.socket.clear_socket_data()
	if end0.socket:
		end0.socket.clear_socket_data()
	queue_free()
			
func add_segment()->void:
	
	var pj :PinJoint2D = final_pinjoint.duplicate()
	var ws :WireSegment = prev_segment.duplicate()
	
	final_pinjoint.position.x+=ws.size.y
	ws.position.x += ws.size.y
	
	add_child(ws)
	add_child(pj)
	
	pj.set_node_a(prev_segment.get_path())
	pj.set_node_b(ws.get_path())
	prev_segment = ws
	final_pinjoint.set_node_a(prev_segment.get_path())




func _on_mouse_on_wire() -> void:
	can_delete = true
	
	for ws in get_children():
		if ws.is_in_group("wire_segment"):
			ws.color = ws.delete_color
			ws.update_color()



func _on_mouse_off_wire() -> void:
	can_delete = false
	for ws in get_children():
		if ws.is_in_group("wire_segment"):
			ws.color = ws.rest_color
			ws.update_color()

	

func data_connected()->bool:
	var d_connected := false
	if end1.socket.data:
		end0.socket.data = end1.socket.data
	elif end0.socket.data:
		end1.socket.data = end0.socket.data

	if end0.socket.data and end1.socket.data:
		end0.socket.data.connected = true
		d_connected = true
	if not d_connected:
		print("wire not connected.  end0 data: ", end0.socket.data, "  end1 data:", end1.socket.data)
	return d_connected
