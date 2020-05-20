extends Line2D

var turtle
var point

export(NodePath) var TurtlePath

var last_point

func _ready():
	turtle = get_node(TurtlePath)
	last_point = Vector2.ZERO
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = Vector2.ZERO
	global_rotation = 0
	point = turtle.global_position
	if int(point.x) == int(last_point.x) and int(point.y) == int(point.y):
		return
	
	
	if turtle.is_pen_up():
		return
	
	add_point(point)
	last_point = point
