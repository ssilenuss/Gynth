
@tool
extends Control

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


func _process(delta):
	pass

func _draw():
	var center := size/2
	draw_circle(center, radius, rim_color)
	draw_circle(center, radius*.9, hole_color)
	

