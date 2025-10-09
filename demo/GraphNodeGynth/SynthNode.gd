extends GraphNode
class_name SynthNode
#https://gdscript.com/solutions/godot-graphnode-and-graphedit-tutorial/
signal synth_node_selected(sn: SynthNode)
enum types{FLOAT, AUDIO}

func _ready() -> void:
	var hbox := get_titlebar_hbox()
	var close_button := Button.new()
	close_button.text = "X"
	hbox.add_child(close_button)
	close_button.pressed.connect(_on_delete_request)

func _on_delete_request() -> void:
	queue_free()

func _on_resize_request(new_size: Vector2) -> void:
	size = new_size


func _on_node_selected() -> void:
	synth_node_selected.emit(self)
