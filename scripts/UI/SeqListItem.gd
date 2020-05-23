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


signal ItemMove
signal ItemRemoved

func move_itm_below(node, idx):
	if node == null:
		return
	
	var t_idx = idx+1
	var prnt = get_parent()
	var ccount = prnt.get_child_count()-1
	
	if idx < ccount and t_idx < ccount:
		var node2 = prnt.get_child(t_idx)
		if node2 != null:
			prnt.remove_child(node)
			prnt.add_child_below_node(node2, node)

func on_btn_act(_id):
	if _id == 0:
		emit_signal("ItemRemoved", self)
		
		queue_free()
	elif _id == 1:
		emit_signal("ItemMove", self, -1)
		#var curr_idx = get_index()
		#if curr_idx != 0:
		#	var prnt = get_parent()
		#	var node2 = prnt.get_child(curr_idx-2)
		#	if node2 != null:
		#		prnt.remove_child(self)
		#		prnt.add_child_below_node(node2, self)
		var idx = get_index()-1
		if idx >= 0:
			var chld = get_parent().get_child(idx)
			move_itm_below(chld, idx)
	elif _id == 2:
		emit_signal("ItemMove", self, 1)
		#var prnt = get_parent()
		#var ccount = prnt.get_child_count()-2
		#var curr_idx = get_index()
		#if curr_idx < ccount:
		#	
		#	var node2 = prnt.get_child(curr_idx+1)
		#	prnt.remove_child(self)
		#	prnt.add_child_below_node(node2, self)
		move_itm_below(self, get_index())

var cmd_idx
var cmd_amnt

func get_cmd_idx() -> int: return cmd_idx
func get_cmd_amnt() -> int: return cmd_amnt





func set_item(idx, amnt):
	cmd_idx = idx
	cmd_amnt = amnt

#var list_idx:int
#func set_idx(idx:int): list_idx=idx
#func get_idx() -> int: return list_idx

func update_text():
	var t = TurtleSettings.get_turtle_cmd_itm_text(cmd_idx, cmd_amnt)
	text_1.text = t[0]
	text_2.text = t[1]

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
	
	btn_rmv.connect("pressed", self, "on_btn_act", [0])
	btn_mv_up.connect("pressed", self, "on_btn_act", [1])
	btn_mv_dwn.connect("pressed", self, "on_btn_act", [2])
