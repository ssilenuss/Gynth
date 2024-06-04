
extends RigidBody2D
class_name WireEnd

var input := true
var socket : Socket = null
var wire : Wire

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
		if Input.is_action_just_pressed("right_mouse_button") and held:
			wire.queue_free()
			print(wire, "  deleted")
		


func _draw():
	draw_circle(Vector2.ZERO, radius+2.0, Color(0,0,0,1))
	draw_circle(Vector2.ZERO, radius, color)
	




