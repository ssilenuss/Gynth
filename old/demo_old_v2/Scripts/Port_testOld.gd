extends Node2D

@export var wire : PackedScene

var wires : Array = []
#
func _process(delta: float) -> void:
	if wires.size()>0:
		if Input.is_action_just_pressed("right_mouse_button"):
			delete_wire()
				#if w.end0.port == null or w.end1.port == null:
					#if w.end0.port:
						#w.end0.port.wire_end = null
					#if w.end1.port:
						#w.end1.port.wire_end = null
					#w.queue_free()
					#w = null
				#else:
					#w.end0.held = false
					#w.end1.held = false
					#w.end0.global_transform.origin = w.end0.port.global_transform.origin
					#w.end1.global_transform.origin = w.end1.port.global_transform.origin
					#w = null
#func _on_in_port_clicked(_port: Socket, _end: WireEnd) -> void:
	#if _end and _port.wire_end == _end:
		#_end.held = true
		#
	#else:
		#w = wire.instantiate()
		#w.position = _port.position
		#add_child(w)
		#_port.wire_end = w.end0
		#w.end0.port = _port
		#w.end0.input = _port.input
		#w.end1.input != _port.input
	#

#
#func _on_end_on_port(_port: Port, _end: WireEnd) -> void:
	#p = _port
	#
#
#func _on_in_end_off_port(_port: Port, _end: WireEnd) -> void:
	#p=null


func _on_socket_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_released("left_mouse_button"):
		pass

func delete_wire() -> void:
	var w = wires.pop_back()
	if w.end0.socket:
		w.end0.socket.jack = null
	if w.end1.socket:
		w.end1.socket.jack = null
	w.queue_free()
	w = null
	
func _on_create_wire(_socket: Socket) -> void:
	if _socket.jack:
		_socket.jack.held = true
		
	else:
		var w = wire.instantiate()
		w.position = _socket.position
		add_child(w)
		wires.append(w)
		
		_socket.jack = w.end0
		w.end0.socket = _socket
		w.end0.input = _socket.input
		w.end1.input = !_socket.input
		#print("end0 input: ", w.end0.input, "  end1input:  ", w.end1.input, )
		if _socket.input:
			w.end0.color = _socket.input_color
			w.end1.color = _socket.output_color
		else:
			w.end0.color=_socket.output_color
			w.end1.color=_socket.input_color
	



func _on_drop_jack(_socket: Socket) -> void:
	var w = wires[wires.size()-1]
	w.end1.held = false
	w.end1.socket = _socket
	_socket.jack = w.end1
	print(_socket.input, w.end1.input)
	w.end1.global_transform.origin = _socket.global_transform.origin




func _on_pickup_jack(_socket: Socket, _jack: WireEnd) -> void:
	_jack.held = true
	_socket.jack = null
	_jack.socket = null
