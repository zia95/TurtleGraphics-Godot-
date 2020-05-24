extends Control

export(NodePath) var SeqButtonPath
export(NodePath) var RunButtonPath

export(NodePath) var SeqScrollControlPath
export(NodePath) var SeqScrollListPath


#const SEQ_ADD_BTN = preload("res://scenes/UIComp/ButtonStandardDefault.tscn")

const SEQ_LIST_ITEM = preload("res://scenes/UIComp/SeqListItem.tscn")
const SEQ_LIST_ADD_ITEM = preload("res://scenes/UIComp/SeqListAddItem.tscn")
#const SEQ_ADD_DLG = preload("res://scenes/UIComp/AddSeqItemDialog.tscn")

var seq_switch_btn : Button
var seq_run_btn : Button
var seq_scroll_control : Control
var seq_scroll_list : VBoxContainer

var __seqlst_itm_add

var __seqlst_itm_add_lst_idx:int
var __seqlst_itm_add_lst_amnt:int




signal RunBtnClicked


#our item array, command item in the list
#var seq_item_arr = []

func seq_on_run_btn():
	#var items = seq_item_arr
	var items = seq_scroll_list.get_children()
	items.pop_back()
	
	var parsed = TurtleSettings.parse_commands(items)
	if parsed == null or parsed.size() <= 0:#show error
		print_debug("sequence data is invalid...")
		$TopBar/ButtonRun/seq_invalid.play()
		return 
	
	emit_signal("RunBtnClicked", parsed)


func on_seq_list_item(idx, amnt):
	__seqlst_itm_add_lst_idx = idx
	__seqlst_itm_add_lst_amnt = amnt
	
	if __seqlst_itm_add != null:
		seq_scroll_list.remove_child(__seqlst_itm_add)
		__seqlst_itm_add.queue_free()
	
	var  lst_itm = list_add_list_item()
	lst_itm.set_item(idx, amnt)
	lst_itm.update_text()
	
	list_add_itm_add()

func list_add_itm_add():
	__seqlst_itm_add = SEQ_LIST_ADD_ITEM.instance()
	
	seq_scroll_list.add_child(__seqlst_itm_add)
	__seqlst_itm_add.set_parent(self)
	__seqlst_itm_add.set_seq_idx(__seqlst_itm_add_lst_idx)
	__seqlst_itm_add.set_seq_amnt(__seqlst_itm_add_lst_amnt)
	
	return __seqlst_itm_add

func list_add_list_item():
	var list_item = SEQ_LIST_ITEM.instance()
	seq_scroll_list.add_child(list_item)
	return list_item

#callback signal
func seq_on_switch_btn():
	#seq_switch_btn.disabled = true
	#print_debug("seq button clicked! state ->" + String(seq_switch_btn.disabled))
	var anm_plr : AnimationPlayer = seq_scroll_control.get_node("AnimationPlayer") 
	
	if anm_plr.is_playing():
		return
	
	if seq_scroll_control.rect_position.x == 0:
		anm_plr.play("hide")
	else:
		anm_plr.play("show")
	#seq_switch_btn.disabled = false

func test_add_dummy_list_item():
	on_seq_list_item(TurtleSettings.TurtleCommands.repeat, 2)
	on_seq_list_item(TurtleSettings.TurtleCommands.forward, 100)
	on_seq_list_item(TurtleSettings.TurtleCommands.left, -1)
	on_seq_list_item(TurtleSettings.TurtleCommands.end_repeat, -1)
	pass

func _ready():
	seq_switch_btn = get_node(SeqButtonPath)
	seq_run_btn = get_node(RunButtonPath)
	seq_scroll_control = get_node(SeqScrollControlPath)
	seq_scroll_list = get_node(SeqScrollListPath)
	
	seq_switch_btn.connect("pressed", self, "seq_on_switch_btn")
	seq_run_btn.connect("pressed", self, "seq_on_run_btn")
	
	list_add_itm_add()
	#test_add_dummy_list_item()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
