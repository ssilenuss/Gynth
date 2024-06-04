extends Node2D
class_name Wire
#@export var segment : PackedScene
@export var segments : int = 3



@onready var end0 :WireEnd = $WireEnd0
@onready var end1 :WireEnd = $WireEnd1
@onready var end :WireEnd = $WireEnd1

var prev_segment: RigidBody2D
var final_pinjoint: PinJoint2D


func _ready() -> void:
	prev_segment = $WireSegment
	final_pinjoint = $PinJoint2D4
	
	remove_child(end1)
	for i in segments:
		add_segment()
	end1 = end.duplicate()
	end1.position = final_pinjoint.position
	end1.input = false

	add_child(end1)
	final_pinjoint.set_node_b(end1.get_path())
	end1.held = true

	

	
func add_segment()->void:
	
	var pj :PinJoint2D = final_pinjoint.duplicate()
	var ws :WireSegment = prev_segment.duplicate()
	
	final_pinjoint.position.x+=ws.size.y
	ws.position.x += ws.size.y
	
	add_child(ws)
	add_child(pj)
	
	pj.set_node_a(prev_segment.get_path())
	pj.set_node_b(ws.get_path())
	prev_segment = ws
	final_pinjoint.set_node_a(prev_segment.get_path())


