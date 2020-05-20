extends VBoxContainer


export(NodePath) var btnExecutePath

export(NodePath) var txtCommandPath

export(NodePath) var TurtlePath


var btnExecute : Button
var txtCommand : TextEdit

var Turtle

func _ready():
	btnExecute = get_node(btnExecutePath)
	txtCommand = get_node(txtCommandPath)
	Turtle = get_node(TurtlePath)
	
	btnExecute.connect("pressed", self, "on_btnExecutePressed")
	
	txtCommand.connect("focus_entered", self, "cmd_focus", [true])
	txtCommand.connect("focus_exited", self, "cmd_focus", [true])

var prev_foc_state:bool
func cmd_focus(foc_state):
	if prev_foc_state == false and foc_state == true:
		txtCommand.text = ""
	prev_foc_state = foc_state

func on_btnExecutePressed():
	Turtle.execute_command(txtCommand.text)
	txtCommand.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
