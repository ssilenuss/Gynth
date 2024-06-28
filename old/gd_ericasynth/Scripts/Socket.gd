@tool
extends Area2D
class_name Socket

signal place_jack()
signal create_wire(_socket: Socket)
signal pickup_jack()

@export var wire_scene : PackedScene
@export var radius :float = 50 :
	set(value):
		radius = value
		$CollisionShape2D.shape.radius = radius
		queue_redraw()
@export var action_color := Color(0.0,1.0,0.0,1.0)
@export var cancel_color := Color(1.0,0.0,0.0,1.0)
@export var input_color := Color(1.0,1.0,0.0,1.0)
@export var output_color := Color(0.0,1.0,1.0,1.0)
@export var rest_color := Color(0.0,0.0,0.0,1.0)

@export var input := false : 
	set(value):
		input = value
		if input:
			rest_color = input_color
		else:
			rest_color = output_color
		color = rest_color
		queue_redraw()


var jack: WireEnd
var mouse_hover := false
var can_accept : WireEnd
var cannot_accept: WireEnd


var color := Color(0.0,0.0,0.0,1.0)

func _ready() -> void:
	if input:
		rest_color = input_color
	else:
		rest_color = output_color
	color = rest_color
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)


func _on_mouse_entered() -> void:
	if cannot_accept or can_accept:
		return
	color = action_color
	mouse_hover = true
	queue_redraw()

func _on_mouse_exited() -> void:
	if cannot_accept or can_accept:
		return
	mouse_hover = false
	color = rest_color
	print("mouse_exited")
	queue_redraw()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if cannot_accept:
				return
			elif jack==null:
				if can_accept:
					place_jack.emit()
				elif mouse_hover:
					create_wire.emit(self)
			else:
				pickup_jack.emit()
			
func _on_body_entered(body: Node2D) -> void:
	if body is WireEnd:
		body.socket = self
		if body.input == input and jack == null:
			can_accept = body
			color = action_color
			queue_redraw()
			print("can accept: ", can_accept)
		else: 
			cannot_accept = body
			color = cancel_color
			queue_redraw()
			print("cannot accept:  ", cannot_accept)
	

func _on_body_exited(body: Node2D) -> void:
	if body is WireEnd:
		body.socket = null
		can_accept = null
		cannot_accept = null
		color = rest_color
		print("body_exited")
		queue_redraw()

func check_if_can_place(_jack: WireEnd)->bool:
	var test := true
	if jack != null:
		test = false
	elif _jack.input != input:
		test = false
	elif _jack.wire == _jack.wire.end0.wire:
		test = false
	return test


func _on_pickup_jack() -> void:
	jack.held = true
	jack.socket = null
	can_accept = jack
	jack = null
	color = action_color
	queue_redraw()



func _on_place_jack() -> void:
	jack = can_accept
	jack.socket = self
	can_accept = null
	cannot_accept = null
	jack.held = false
	jack.global_transform.origin = self.global_transform.origin
	color = rest_color
	print("jack_placed")
	queue_redraw()


func _on_create_wire(_socket: Socket) -> void:

	var w = wire_scene.instantiate()
	w.position = _socket.position
	get_tree().get_first_node_in_group("wire_holder").add_child(w)

	
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

	pass # Replace with function body.
