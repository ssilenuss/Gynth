@tool
extends Control
class_name Socket

signal place_jack()
signal create_wire(_socket: Socket)
signal pickup_jack()
signal wire_connected(_data: Synth_Data)
signal wire_disconnected()

var center := size/2


@export var radius : float = 0: set = set_radius
func set_radius(_v):
		radius = _v
		custom_minimum_size = 2*Vector2(radius, radius)
		queue_redraw()
@export var hole_color : Color: 
	set(_v):
		hole_color = _v
		queue_redraw()
@export var rim_color : Color: 
	set(_v):
		rim_color = _v
		queue_redraw()

@export var data : Synth_Data : 
	set(value):
		data = value

@onready var wire_scene : PackedScene = preload("res://Scenes/wire.tscn")

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
		hole_color = rest_color
		queue_redraw()


var jack: WireEnd
var mouse_hover := false
var can_accept : WireEnd
var cannot_accept: WireEnd

func _ready()->void:
	socket_resized()
	input = input
	set_mouse_filter(Control.MOUSE_FILTER_PASS)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	place_jack.connect(_on_place_jack)
	pickup_jack.connect(_on_pickup_jack)
	create_wire.connect(_on_create_wire)
	resized.connect(socket_resized)
func socket_resized()->void:
	set_radius(min(size.x, size.y)/2)
	queue_redraw()
func _gui_input(event):
	#print(event)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		check_socket_data()
		if not check_mouse_dist():
			pass
		elif cannot_accept:
				return
		elif jack==null:
			if can_accept:
				place_jack.emit()
			elif mouse_hover:
				create_wire.emit(self)
		else:
			pickup_jack.emit()

func _draw():
	center = size/2
	draw_circle(center, radius, rim_color)
	draw_circle(center, radius*.95, hole_color)
	draw_circle(center, radius*.9, rim_color)
	draw_circle(center, radius*.85, hole_color)
	

func _on_mouse_entered() -> void:
	check_socket_data()
	
	if cannot_accept or can_accept:
		print("can't: ", cannot_accept, "   can: ", can_accept)
		return
	elif Singleton.held_wire != null:
		Singleton.held_wire.socket = self
		if Singleton.held_wire.input == input and jack == null:
			can_accept = Singleton.held_wire
			hole_color = action_color
			queue_redraw()

		else: 
			cannot_accept = Singleton.held_wire
			hole_color = cancel_color
			queue_redraw()

	else:
		hole_color = action_color
		mouse_hover = true
		queue_redraw()
func check_mouse_dist()->bool:
	var close_enough := false
	var p = center + get_global_transform().origin
	var m = get_global_mouse_position()
	close_enough = (p.distance_to(m)<radius)
	#print("close enough: ", close_enough, " dist: ", p.distance_to(m))
	#print("center: ", p, " mouse: ", m, " radius: ", radius)
	return close_enough

func _on_mouse_exited() -> void:
	check_socket_data()
	if Singleton.held_wire != null:
		can_accept = null
		cannot_accept = null
		hole_color = rest_color
		queue_redraw()
	else:
		mouse_hover = false
		hole_color = rest_color
		queue_redraw()



func _on_pickup_jack() -> void:
	
	if Singleton.held_wire:
		return


	data = null
	Singleton.held_wire = jack
	jack.held = true
	jack.socket = null
	can_accept = jack
	jack = null
	wire_disconnected.emit()
	hole_color = action_color
	queue_redraw()

func check_socket_data()->void:
	if not is_instance_valid(data):
		data = null
	if not is_instance_valid(jack):
		jack = null
	if not is_instance_valid(cannot_accept):
		cannot_accept = null
	if not is_instance_valid(can_accept):
		can_accept = null
	if not is_instance_valid(Singleton.held_wire):
		Singleton.held_wire = null

func clear_socket_data()->void:
	if input:
		data = null
	jack = null
	can_accept = null
	cannot_accept = null

func _on_place_jack() -> void:
	if not is_instance_valid(can_accept):
		return
	jack = can_accept
	jack.socket = self
	can_accept = null
	Singleton.held_wire = null
	var connected :bool = jack.wire.data_connected()
	if connected:
		wire_connected.emit(data)
		#print("jack placed.  wire connected: ", connected)
	cannot_accept = null
	jack.held = false
	jack.global_transform.origin = self.center + get_global_transform().origin
	hole_color = rest_color
	queue_redraw()


func _on_create_wire(_socket: Socket) -> void:

	var w = wire_scene.instantiate()
	w.position = _socket.center + _socket.get_global_transform().origin
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
	

