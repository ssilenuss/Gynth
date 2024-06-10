
extends RigidBody2D
class_name WireSegment

signal mouse_on_wire
signal mouse_off_wire

@export var size := Vector2(5,40):
	set(value):
		size = value
		$CollisionShape2D.shape.radius = size.x/2
		$CollisionShape2D.shape.height = size.y
		$ColorRect.size = size
		$ColorRect.position = -size/2
		queue_redraw()
		
var color : Color = Color(1,1,0,1)
@export var rest_color := Color(1,1,0,1)
@export var delete_color := Color(1, 0, 0, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	color = rest_color
	
	$CollisionShape2D.shape.radius = size.x/2
	$CollisionShape2D.shape.height = size.y
	$ColorRect.size = size
	$ColorRect.color = color
	$ColorRect.position = -size/2

func update_color()->void:
	$ColorRect.set_color(color)

	
func _on_mouse_entered() -> void:
	mouse_on_wire.emit()



func _on_mouse_exited() -> void:
	mouse_off_wire.emit()



