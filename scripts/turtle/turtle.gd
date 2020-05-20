extends KinematicBody2D

export(NodePath) var lineContainerPath
export (int) var speed = 1
export(bool) var pen_up = false
export(int) var pen_width = 5

var turtle_pen_arr = []
var turtle_pen

var timer_speed
#var pen_up:bool

class TurtleCommander:
	
	enum CType { FORWARD, BACKWARD, ROTATE }
	
	var _turtle
	var _command_type
	var _command_val:int
	
	var next_command  : TurtleCommander
		
	#func _init(turtle, com_type, com_val):
	#	set_vars(turtle, com_type, com_val)
	
	func set_vars(turtle, com_type, com_val):
		self._turtle = turtle
		self._command_type = com_type
		self._command_val = com_val
		self.next_command = null
	
	func set_obj(com : TurtleCommander):
		self._turtle = com._turtle
		self._command_type = com.com_type
		self._command_val = com.com_val
		self.next_command = null
	
	
	func done():
		return _command_val == 0
	
	func set_command(command : TurtleCommander):
		next_command = command
	
	func do_curr():
		if done():
			return false
		
		if _command_type == CType.FORWARD:
			_turtle.turtle_move_forward(10)
			_command_val -= 1
		if _command_type == CType.BACKWARD:
			_turtle.turtle_move_forward(-10)
			_command_val -= 1
		if _command_type == CType.ROTATE:
			_turtle.turtle_rotate(_command_val)
			_command_val = 0
		
		return true
	

var turtle_commander : TurtleCommander

func execute_command(command):
	
	if command == "lft":
		turtle_commander.set_vars(self, TurtleCommander.CType.ROTATE, -90)
		command = "added"
	
	if command == "rgt":
		turtle_commander.set_vars(self, TurtleCommander.CType.ROTATE, 90)
		command = "added"
	
	if command == "pu":
		pen_up = true
		set_pen(pen_up)
	
	if command == "pd":
		pen_up = false
		set_pen(pen_up)
	
	if command.begins_with("fd"):
		command.erase(0, 2)
		var dist = command.to_int()
		turtle_commander.set_vars(self, TurtleCommander.CType.FORWARD, dist)
	
	
	if command.begins_with("bw"):
		command.erase(0, 2)
		var dist = command.to_int()
		turtle_commander.set_vars(self, TurtleCommander.CType.BACKWARD, dist)
	
	
	if command.begins_with("spd"):
		command.erase(0, 3)
		speed = command.to_int()
		turtle_set_speed(speed)
	
	if command.begins_with("rot"):
		command.erase(0, 3)
		var rot = command.to_int()
		turtle_commander.set_vars(self, TurtleCommander.CType.ROTATE, rot)
	
	#print_debug(command)

# BEGINING OF TURTLE MOVEMENT



func turtle_move_forward(step_speed):
	var velocity = Vector2(0, -step_speed).rotated(rotation)
	#velocity = move_and_slide(velocity)
	move_and_collide(velocity)
	#print_debug("++++++++++++++++speed: " + String(global_position))

func turtle_rotate(rot):
	global_rotation_degrees = global_rotation_degrees + rot
	#print_debug("timer ____ rotdeg:" + String(global_rotation_degrees) + "rot:" + String(rot))

#speed must be between 1...
func turtle_set_speed(spd:int):
	if spd <= 0:
		spd = 1
	
	if spd >= 10:
		spd = 10
	
	var speed_to_wt = float(spd)/1000
	print_debug("timer ____ waitT:" + String(speed_to_wt) + "____spd:" + String(spd))
	timer_speed.set_wait_time(speed_to_wt)

func turtle_set_speed_timer():
	timer_speed = get_node("TimerSpeed")
	turtle_set_speed(speed)
	timer_speed.connect("timeout", self, "timer_speed_timeout")
	timer_speed.start();

var line_last_point
func timer_speed_timeout():
	if turtle_commander != null:
		turtle_commander.do_curr()
	
	#line draw......
	if is_pen_up() == false:
		var new_point = self.global_position
		
		if line_last_point != null and int(new_point.x) == int(line_last_point.x) and int(new_point.y) == int(line_last_point.y):
			return
		
		#if line_last_point == null:
		#	new_point.x -= 10
		
		if turtle_pen.points.empty() and line_last_point != null:
			new_point = line_last_point
		
		turtle_pen.add_point(new_point)
		line_last_point = new_point
	else:
		line_last_point = null
		
		# end of line draw.......
	

func set_pen(up_or_down:bool):
	if up_or_down == true:
		turtle_pen = null
		#line_last_point = null
	else:
		turtle_new_pen()

func is_pen_up():
	return turtle_pen == null

func turtle_new_pen():
	var __ln_pen = load("res://scripts/turtle/TurtlePen.gd")
	turtle_pen = __ln_pen.new(self)
	
	turtle_pen.width = pen_width
	turtle_pen.default_color = Color.blue

# END OF TURTLE MOVEMENT

func _ready():
	turtle_commander = TurtleCommander.new()
	turtle_set_speed_timer()
	set_pen(pen_up)


func _physics_process(delta):
	pass
