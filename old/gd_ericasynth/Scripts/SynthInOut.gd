@tool
extends Control
class_name SynthInOut

var empty := true
var center := size/2
signal in_out_clicked(_inout:Control, center:Vector2)

@export var radius : float = -5.0: set = set_radius
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

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if empty:
			emit_signal("in_out_clicked", self, center)
		else:
			pass

func _draw():
	center = size/2
	draw_circle(center, radius, rim_color)
	draw_circle(center, radius*.95, hole_color)
	draw_circle(center, radius*.9, rim_color)
	draw_circle(center, radius*.85, hole_color)
	

