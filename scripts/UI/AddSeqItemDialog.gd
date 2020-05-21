extends PopupDialog

export(NodePath) var SeqTypePath
export(NodePath) var AmountContainerPath

export(NodePath) var AmountTextPath

export(NodePath) var btnClosePath
export(NodePath) var btnAddPath

var seq_type : OptionButton

var amount_container : HBoxContainer

var ammount_result : int

func get_ammount():
	return ammount_result


var seq_item = [ "left", "right", "penup", "pendown", "forward", "backward", "rotation", "repeat" ]

func populate_seq():
	for itm in seq_item:
		seq_type.add_item(itm)
	fix_amnt_container(seq_type.get_selected_id())

func fix_amnt_container(id):
	amount_container.visible = (id > 3)

func seq_type_on_itm_selected(id):
	fix_amnt_container(id)

var __prnt

func showdlg(prnt):
	__prnt = prnt
	prnt.add_child(self)
	self.popup_centered_ratio()
	pass

func on_dlg_result(add_or_cls):
	if add_or_cls:
		ammount_result = get_node(AmountTextPath).text.to_int()
		if amount_container.visible == false:
			ammount_result = -1
		__prnt.on_seq_itmdlg(seq_item[seq_type.get_selected_id()], ammount_result)
	
	self.queue_free()

func _ready():
	seq_type = get_node(SeqTypePath)
	amount_container = get_node(AmountContainerPath)
	populate_seq()
	seq_type.connect("item_selected", self, "seq_type_on_itm_selected")
	
	get_node(btnClosePath).connect("pressed", self, "on_dlg_result", [false])
	get_node(btnAddPath).connect("pressed", self, "on_dlg_result", [true])
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
