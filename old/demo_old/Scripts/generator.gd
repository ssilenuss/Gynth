extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamOscillator.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print($AudioStreamOscillator.is_playing())
	if Input.is_action_just_pressed("ui_down"):
		$AudioStreamOscillator.set_generating(!$AudioStreamOscillator.generating)
	print($AudioStreamOscillator.to_fill)
	pass
