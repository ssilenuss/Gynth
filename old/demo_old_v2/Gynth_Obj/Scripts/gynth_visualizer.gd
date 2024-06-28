extends Node3D

var camera : Camera3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_viewport().get_camera_3d()

func _process(delta: float) -> void:
	look_at(camera.global_transform.origin,Vector3(0,1,0), true)
	
func init_menu()->void:
	
