extends Node2D

@export var wire : PackedScene

func _on_create_wire(_socket: Socket) -> void:

	var w = wire.instantiate()
	w.position = _socket.position
	add_child(w)
	
	_socket.jack = w.end0
	w.end0.socket = _socket
	w.end0.input = _socket.input
	w.end1.input = !_socket.input
	
	if _socket.input:
		w.end0.color = _socket.input_color
		w.end1.color = _socket.output_color
	else:
		w.end0.color=_socket.output_color
		w.end1.color=_socket.input_color
	
	print("wire created", w)
