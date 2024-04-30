
extends Node

@onready var end0 :WireEnd = $WireEnd0
@onready var end1 :WireEnd = $WireEnd1

var moving := true
var add_dist :float = 10.0
var segments : Array = []
var pinjoints : Array = [

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		moving = !moving
	if moving:
		end1.global_position = end1.get_global_mouse_position()
		var dist = end0.global_position.distance_to(end1.global_position)
		print(dist)
	pass

func add_segment()->void:
	pass
