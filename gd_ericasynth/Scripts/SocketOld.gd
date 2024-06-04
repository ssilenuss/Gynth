extends Area2D
class_name Socket

signal drop_jack(_socket: Socket)
signal create_wire(_socket: Socket)
signal pickup_jack(_socket: Socket, _jack : WireEnd)


@export var radius :float = 50 :
	set(value):
		radius = value
		$CollisionShape2D.shape.radius = radius
		queue_redraw()
@export var jack_hover_color : Color
@export var mouse_hover_color := Color(0.0,1.0,0.0,1.0)
@export var cancel_color := Color(1.0,0.0,0.0,1.0)
@export var input_color := Color(1.0,1.0,0.0,1.0)
@export var output_color := Color(0.0,1.0,1.0,1.0)
@export var rest_color := Color(0.0,0.0,0.0,1.0)

@export var input := false

var jack: WireEnd
var mouse_hover := false
var jack_hover := false
var can_accept := false


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
	if jack_hover or can_accept:
		return
	else:
		color = mouse_hover_color
		mouse_hover = true
		queue_redraw()

func _on_mouse_exited() -> void:
	mouse_hover = false
	color = rest_color
	queue_redraw()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if jack==null:
				if can_accept:
					drop_jack.emit(self)
				elif mouse_hover:
					create_wire.emit(self)
			else:
				pickup_jack.emit(self, jack)
			
func _on_body_entered(body: Node2D) -> void:
	if body is WireEnd:
		jack_hover = true
		if body.input == input and jack == null:
			can_accept = true
			color = mouse_hover_color
			queue_redraw()
	#print(input, body.input)
		#print("jack_hover: ", jack_hover, "  input match:  ", (body.input == input))



	#var we : WireEnd = body
	#jack = we
	#
	#if we.input == input:
		#jack.socket = self
		#color = jack_hover_color
	#else:
		#color = cancel_color
		#jack.port = null
	#queue_redraw()


func _on_body_exited(body: Node2D) -> void:
	if body is WireEnd:
		jack_hover = false
		can_accept = false
		color = rest_color
		queue_redraw()
		
		

	#var we : WireEnd = body
	#jack = we
	#jack.port = null
	#jack = null
	#color = rest_color
	#queue_redraw()
#
