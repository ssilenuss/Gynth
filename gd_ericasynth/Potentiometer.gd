@tool
extends HSlider
class_name potentiometer


@export var radius : float = -5.0: 
	set(_v):
		radius = _v
		custom_minimum_size.x = 2*radius
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
#@export var value : float =0: 
	#set(_v):
		#value = clampf(_v, 0.0, 1.0)
		#queue_redraw()
var line_pos := Vector2(size.x/2, size.y/2-radius)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	queue_redraw()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	var center = size/2
	var max_rad = .8*TAU
	var offset = 5
	var l_p:Vector2 = line_pos.rotated(max_rad*value)

	draw_circle(center, radius, pot_color)
	draw_line(center, l_p, line_color, 2.0 )
	
	for l in 11.0:
		var ls_p = Vector2(size.x/2,line_pos.y-offset)
		var pos1 := ls_p.rotated(l/10.0*max_rad)
		var pos2 := pos1*1.5
		draw_line(pos1, pos2, line_color, 1.0)
		
