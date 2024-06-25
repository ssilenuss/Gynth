extends ColorRect
class_name Envelope_Scope


var attack : float = 0.0
var decay_release : float = 0.0
var sustain : float = 0.0
var points : PackedVector2Array = []
var control_points : PackedVector2Array = []

var logerp_points : PackedVector2Array = []

@export var line_color :Color = Color(1.0,0.0,0.0,1.5) :
	set(value):
		line_color = value

		queue_redraw()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resized() -> void:
	queue_redraw()


func _on_decay_release_changed(value: float)->void:
	decay_release = value
	queue_redraw()


func _on_attack_changed(value: float) -> void:
	attack = value
	queue_redraw()



func _on_sustain_changed(value: float) -> void:
	sustain = value
	queue_redraw()

func generate_points()->void: 
	points = []
	logerp_points = []
	var max_x : float = attack + decay_release + decay_release
	
	var attack_x : float = attack/max_x
	var dr_x :float = decay_release/max_x
	#dr_x = dr_x*dr_x
	
	var cp_line_start := Vector2(0.0,size.y)
	var cp_attack_curve := Vector2(0.0,0.0)
	var cp_attack_end := Vector2(attack_x * size.x, 0.0)
	var cp_decay_curve:= Vector2(attack_x *size.x, (1.0-sustain)*size.y)
	var cp_decay_end := Vector2((attack_x+dr_x)*size.x, (1.0-sustain)*size.y)
	var cp_release_curve := Vector2((attack_x+dr_x)*size.x, size.y)
	var cp_release_end:=Vector2(size.x, size.y)

	control_points = [cp_line_start, cp_attack_curve, cp_attack_end, cp_decay_curve, cp_decay_end, cp_release_curve, cp_release_end]
	
	for x in size.x:
		var p : Vector2
		var lp : Vector2
		var t_x : float = x/size.x
		
		if t_x <= attack_x:
			p = Singleton._quadratic_bezier(cp_line_start,cp_attack_curve,cp_attack_end,t_x/attack_x)
			lp.y = Singleton.logerp(size.y+1.0, 1.0, t_x/attack_x)-1.0
			

	#
		elif t_x <= attack_x+ dr_x:
			var t : float = (t_x-attack_x)/dr_x
			p = Singleton._quadratic_bezier(cp_attack_end,cp_decay_curve,cp_decay_end,t)
			lp.y = cp_decay_end.y - Singleton.logerp( cp_decay_end.y+1.0, 1.0, t)-1.0
			
		else:
			var t : float = (t_x-attack_x-dr_x)/dr_x
			p = Singleton._quadratic_bezier(cp_decay_end,cp_release_curve,cp_release_end,t)
			lp.y = size.y- Singleton.logerp(sustain*size.y, 1.0, t)
		lp.x = x
		points.append(p)
		logerp_points.append(lp)

	
func _draw() -> void:
	return
	generate_points()
	#draw_polyline(points, line_color, 2.0, true)
	draw_polyline(logerp_points, Color(0,1,0,1), 1.0, true)
	for c in control_points:
		draw_circle(c, 2.0, Color(0,0,1,1),true)
	

	
