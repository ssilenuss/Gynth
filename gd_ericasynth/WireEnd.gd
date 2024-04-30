@tool
extends StaticBody2D
class_name WireEnd

var color : Color = Color(0,0,0,0)
var radius : float = 5
@onready var pin : PinJoint2D = $PinJoint2D

func _ready():
	
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
