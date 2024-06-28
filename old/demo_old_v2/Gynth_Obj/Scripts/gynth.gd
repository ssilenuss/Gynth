extends Node3D

@export var gynths : int = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if get_child_count()<gynths:
		#var g := Gynth_3D_GD.new()
		#add_child(g)
		#g.set_generating(true)
	#print(get_child_count())
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:		
	pass


func _on_timer_timeout() -> void:
	for i in gynths:
		var g := Gynth_3D_GD.new()
		self.add_child(g)
		#g.pitch = randf()
		#print(g)
		#$Timer.start()
