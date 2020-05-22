extends NinePatchRect


export(NodePath) var LabelText1Path
export(NodePath) var LabelText2Path

export(NodePath) var MoveUpButtonPath
export(NodePath) var MoveDownButtonPath
export(NodePath) var RemoveButtonPath

var text_1 : Label
var text_2 : Label

var btn_mv_up : Button
var btn_mv_dwn : Button
var btn_rmv : Button

func set_text(txt1, txt2):
	text_1.text = txt1
	text_2.text = txt2

func get_btn_rmv():
	return btn_rmv

func get_btn_mv_up():
	return btn_mv_up

func get_btn_mv_dwn():
	return btn_mv_dwn

func _ready():
	text_1 = get_node(LabelText1Path)
	text_2 = get_node(LabelText2Path)
	
	btn_mv_up = get_node(MoveUpButtonPath)
	btn_mv_dwn = get_node(MoveDownButtonPath)
	btn_rmv = get_node(RemoveButtonPath)
