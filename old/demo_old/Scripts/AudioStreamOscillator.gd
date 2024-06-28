extends AudioStreamOscillator


# Called when the node enters the scene tree for the first time.
func _ready():
	set_generating(false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(generating)
