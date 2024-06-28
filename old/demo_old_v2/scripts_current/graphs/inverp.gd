@tool
extends ColorRect

var yellow_points :PackedVector2Array = []
var green_points :PackedVector2Array = []
var red_points :PackedVector2Array = []
var blue_points :PackedVector2Array = []

@export var test := false :
	set(value):
		test = false
		queue_redraw()
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass	

func logerp(_from:float, _to:float, _t: float)->float:
	return _from*pow(_to/_from, _t)
	#return a*pow(b/a, t);
	#return start + (end - start) * Mathf.Pow(t, weight);

func inverp(_from:float, _to:float, _t: float)->float:
	return _from*sqrt(_to/_from)/sqrt(_t)
	#return _to*( log(_to/_from)/log(_t) )
	#return return end - (end - start) * Mathf.Log(t, weight);

func generate_blue_points()->void:
	blue_points = []
	var p:= Vector2.ZERO
	for x in size.x:
		p.x = x
		p.y = size.y - logerp(1.0, size.y, x/size.x)		
		blue_points.append(p)
		
func generate_red_points()->void:
	red_points = []
	var p:= Vector2.ZERO
	for x in size.x:
		p.x = x
		#p.y = inverp(size.y, 1.0, x/size.x)
		p.y = size.y - logerp(size.y, 1.0, x/size.x)		
		#print(p)
		red_points.append(p)

		

func generate_green_points()->void:
	green_points = []
	var p:= Vector2.ZERO
	for x in size.x:
		p.x = x
		p.y = logerp(size.y, 1.0, x/size.x)
		green_points.append(p)

func generate_yellow_points()->void:
	yellow_points = []
	var p:= Vector2.ZERO
	for x in size.x:
		p.x = x
		p.y = logerp(1.0, size.y, x/size.x)
		yellow_points.append(p)
	#print(p)
func _draw() -> void:
	generate_yellow_points()
	for p in yellow_points:
		draw_circle(p, 2.0, Color(1.0,1.0,0.0,1.0))
	generate_green_points()
	for p in green_points:
		draw_circle(p, 2.0, Color(0.0,1.0,0.0,1.0))
	generate_blue_points()
	for p in blue_points:
		draw_circle(p, 2.0, Color(0.0,0.0,1.0,1.0))
	generate_red_points()
	for p in red_points:
		draw_circle(p, 2.0, Color(1.0,0.0,0.0,1.0))
