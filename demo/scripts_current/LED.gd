@tool
extends ColorRect

var brightness : float = 1.0 : 
	set(value):
		brightness = value
		queue_redraw()
var radius : float = 5.0 : 
	set(value):
		radius = value
		queue_redraw()
		
func _ready() -> void:
	radius = min(size.x, size.y)/4.0
	queue_redraw()
func _draw() -> void:
	draw_circle(size/2,radius, Color(brightness,0.0,0.0,1.0))
	print(radius)


func _on_resized() -> void:
	_ready()


func _on_value_changed() -> void:
	pass
