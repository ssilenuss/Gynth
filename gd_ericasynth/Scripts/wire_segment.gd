@tool
extends RigidBody2D
class_name WireSegment

@export var size := Vector2(5,40):
	set(value):
		size = value
		$CollisionShape2D.shape.radius = size.x/2
		$CollisionShape2D.shape.height = size.y
		$ColorRect.size = size
		$ColorRect.position = -size/2
		queue_redraw()
		
var color : Color = Color(1,1,0,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	queue_redraw()
	$CollisionShape2D.shape.radius = size.x/2
	$CollisionShape2D.shape.height = size.y
	$ColorRect.size = size
	$ColorRect.color = color
	$ColorRect.position = -size/2
