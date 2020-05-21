extends Control

export(NodePath) var SeqButtonPath
export(NodePath) var SeqScrollContainerPath
export(NodePath) var SeqScrollListPath

const SEQ_ADD_BTN = preload("res://scenes/UIComp/ButtonSequenceListAdd.tscn")
const SEQ_LIST_ITEM = preload("res://scenes/UIComp/SeqListItem.tscn")

const SEQ_ADD_DLG = preload("res://scenes/UIComp/AddSeqItemDialog.tscn")

var seq_switch_btn : TextureButton
var seq_scroll_container : ScrollContainer
var seq_scroll_list : VBoxContainer

var __cur_btn_add
func on_seq_itmdlg(seq, amt):
	seq_scroll_list.remove_child(__cur_btn_add)
	__cur_btn_add.queue_free()
	if amt == -1:
		list_add_list_item().set_text("-> " + seq)
	else:
		list_add_list_item().set_text("-> " + seq + " -> " + String(amt))
	list_add_btn_add()


#callback signal
func list_on_add_btn(add_btn: TextureButton):
	__cur_btn_add = add_btn
	var add_dlg = SEQ_ADD_DLG.instance()
	add_dlg.showdlg(self)

func list_add_btn_add():
	var add_btn = SEQ_ADD_BTN.instance()
	seq_scroll_list.add_child(add_btn)
	add_btn.connect("pressed", self, "list_on_add_btn", [add_btn])
	return add_btn

func list_add_list_item():
	var list_item = SEQ_LIST_ITEM.instance()
	seq_scroll_list.add_child(list_item)
	return list_item

#callback signal
func seq_on_switch_btn():
	seq_scroll_container.visible = !seq_scroll_container.visible

func _ready():
	seq_switch_btn = get_node(SeqButtonPath)
	seq_scroll_container = get_node(SeqScrollContainerPath)
	seq_scroll_list = get_node(SeqScrollListPath)
	
	seq_switch_btn.connect("pressed", self, "seq_on_switch_btn")
	
	list_add_btn_add()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
