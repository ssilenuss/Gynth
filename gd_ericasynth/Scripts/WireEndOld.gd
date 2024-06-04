
extends RigidBody2D
class_name WireEnd

var input := true
var socket : Socket = null
#
#signal picked (_input: bool)

var color : Color = Color(1,0,0,1)
@export var radius : float = 20 :
	set(value):
		radius = value
		$CollisionShape2D.shape.radius = radius
		queue_redraw()
		
var held : bool = false

func _ready():
	$CollisionShape2D.shape.radius = radius
	queue_redraw()
	
func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position()


func _draw():
	draw_circle(Vector2.ZERO, radius, color)

#
#func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed:
			#pickup()
			#
			#
#func pickup():
	#emit_signal("picked", input)
##
#func drop():
	#held = false
#
#
#


