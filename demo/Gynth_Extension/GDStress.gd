extends Node3D

var num:int = 10
@export var cube : PackedScene 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	for i in num:
		var o = Gynth_3D_GD.new()
		add_child(o)
		o.generating = true
		o.pitch = randf()*3+0.5
	
		o.position = random_on_sphere(10)
		o.attenuation = 9.9
		
		var c := cube.instantiate()
		o.add_child(c)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func random_on_sphere(radius : float) -> Vector3:
	var theta = 2 * PI * randf()
	var phi = PI * randf()
	var x = sin(phi) * cos(theta) * radius
	var y = sin(phi) * sin(theta) * radius	
	var z = cos(phi) * radius
	return Vector3(x,y,z)
