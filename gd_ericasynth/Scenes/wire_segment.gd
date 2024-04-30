extends RigidBody2D
class_name WireSegment

var radius :float = 5.0
var height : float = 22.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.shape.radius = radius
	$CollisionShape2D.shape.height = height


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
