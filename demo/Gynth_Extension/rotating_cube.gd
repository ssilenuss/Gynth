extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation.x = randf()*TAU
	rotation.y = randf()*TAU
	rotation.z = randf()*TAU


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_rotate(Vector3.UP,0.01)
