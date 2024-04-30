extends ColorRect

var array : PackedVector2Array = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():

	
	for i in array.size():
		var inc : float = lerpf(0, size.x, i/array.size())
		array[i].x = (float(i)/array.size())*size.x
		array[i].y = (array[i].y*size.y/2)+size.y/2

	draw_polyline(array, Color(1,1,1,1),1.0)
	pass
