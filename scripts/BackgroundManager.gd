extends Node2D

var speed : float = 150.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var index = 1
	for child in get_children():
		if index >= get_child_count():
			break
		child.position.x -= 150.0 * delta * 1.0 / index
		if child.position.x <= -960.0:
			child.position.x += 960.0
		index += 1
