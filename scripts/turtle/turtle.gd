extends KinematicBody2D

export(NodePath) var UIPath

export (int) var speed = 1
export(bool) var pen_up = false
export(int) var pen_width = 5


var turtle_ui


var turtle_pen_arr = []
var turtle_pen

var timer_speed
#var pen_up:bool



class TurtleCommanderInterpreterr:
	
	var turtle
	var run_data
	var curr_cmd_idx:int
	
	var is_done
	var commands_array
	
	func _init():
		is_done = true
		commands_array = TurtleSettings.get_turtle_cmd_str()
	
	func set_and_run(turtl, run_dt):
		curr_cmd_idx = 0
		is_done = false
		turtle = turtl
		run_data = run_dt
	
	func done():
		return is_done
	
	func do():
		if done():
			return false
		var curr_cmd : TurtleSettings.TurtleCommand = run_data[curr_cmd_idx]
		
		
		
		match curr_cmd.cmd_idx:
			TurtleSettings.TurtleCommands.left:
				turtle.turtle_rotate(-90)
			TurtleSettings.TurtleCommands.right:
				turtle.turtle_rotate(90)
			TurtleSettings.TurtleCommands.penup:
				turtle.set_pen(true)
			TurtleSettings.TurtleCommands.pendown:
				turtle.set_pen(false)
			TurtleSettings.TurtleCommands.end_repeat:
				print_debug("end_repeat")
				var rpt = curr_cmd.do_repeat()
				if rpt >= 0:
					curr_cmd_idx = rpt
			TurtleSettings.TurtleCommands.repeat:
				print_debug("repeat ->" + String(curr_cmd.total_amnt))
				# do we want to ignore repeat???
			TurtleSettings.TurtleCommands.forward:
				turtle.turtle_move_forward(1)
			TurtleSettings.TurtleCommands.backward:
				turtle.turtle_move_forward(-1)
			TurtleSettings.TurtleCommands.rotation:
				turtle.turtle_rotate(curr_cmd.total_amnt)
		
		curr_cmd.get_amount_and_dec()
		if curr_cmd.is_finished():
			curr_cmd_idx += 1
			curr_cmd.reset()
			
			if curr_cmd.cmd_idx == TurtleSettings.TurtleCommands.end_repeat:
				curr_cmd_idx = curr_cmd.idx+1
				#print_debug("index is " + String(curr_cmd_idx))
		
		if run_data.size() <= curr_cmd_idx:
			is_done = true
		
	

var turtle_inter : TurtleCommanderInterpreterr

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
	print_debug("timer ____ waitT:" + String(timer_speed.wait_time) + "____spd:" + String(spd))
	timer_speed.set_wait_time(speed_to_wt)

func turtle_set_speed_timer():
	timer_speed = get_node("TimerSpeed")
	turtle_set_speed(speed)
	timer_speed.connect("timeout", self, "timer_speed_timeout")
	timer_speed.start();

var line_last_point
func timer_speed_timeout():
	if turtle_inter != null:
		turtle_inter.do()
	
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

func on_run_btn_pressed(run_data):
	turtle_inter.set_and_run(self, run_data)

func _ready():
	turtle_ui = get_node(UIPath)
	turtle_inter = TurtleCommanderInterpreterr.new()
	turtle_set_speed_timer()
	set_pen(pen_up)
	
	turtle_ui.connect("RunBtnClicked", self, "on_run_btn_pressed")
