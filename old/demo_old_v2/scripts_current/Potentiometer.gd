@tool
extends HSlider
class_name potentiometer


@export var radius : float = -5.0: set = set_radius
func set_radius(_v):
		radius = _v
		custom_minimum_size = 2*Vector2(radius, radius)
		line_pos = Vector2(0,-radius)
		queue_redraw()
@export var pot_color : Color: 
	set(_v):
		pot_color = _v
		queue_redraw()
@export var line_color : Color: 
	set(_v):
		line_color = _v
		queue_redraw()

var init := false
#@export var value : float =0: 
	#set(_v):
		#value = clampf(_v, 0.0, 1.0)
		#queue_redraw()
var line_pos := Vector2(0, -radius)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	value_changed.emit(value)
	queue_redraw()
	
func _process(delta: float) -> void:
	if not init:
		value_changed.emit(value)
		init = true
func _draw():
	var center := size/2
	var max_rad := .8*TAU
	var angle : float =.4028*TAU
	var offset = 5
	var l_p:Vector2 = line_pos
	l_p = l_p.rotated((max_rad*value)-angle)+center

	draw_circle(center, radius, pot_color)
	draw_line(center, l_p, line_color, 2.0 )
	
	for l in 11.0:
		var ls_p = line_pos + Vector2(0,-offset)
		var pos1 :Vector2 = ls_p.rotated((l/10.0*max_rad)-angle)
		var pos2 := pos1*1.5
		draw_line(pos1+center, pos2+center, line_color, 1.0)
		
