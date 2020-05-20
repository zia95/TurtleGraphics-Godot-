extends Line2D


var turtle

func _init(turtle_node):
	turtle = turtle_node
	turtle.add_child(self)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if turtle == null:
		return
	self.global_position = Vector2.ZERO
	self.global_rotation = 0
