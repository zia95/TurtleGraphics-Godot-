extends NinePatchRect


export(NodePath) var SeqTypePath
export(NodePath) var AmountContainerPath

export(NodePath) var AmountTextPath

export(NodePath) var btnAddPath

var seq_type : OptionButton
var amount_container : HBoxContainer

var txtedt_seq_amnt : TextEdit

var ammount_result : int

func get_ammount():
	return ammount_result

var _parent
func set_parent(prnt):
	self._parent = prnt

func set_seq_idx(seq_idx:int):
	if seq_idx >= 0:
		seq_type.select(seq_idx)
		fix_amnt_container(seq_idx)

func set_seq_amnt(seq_amnt:int):
	if seq_amnt > 0:
		txtedt_seq_amnt.text = String(seq_amnt)

var seq_item = [ "left", "right", "penup", "pendown","end repeat", "repeat", "forward", 
"backward", "rotation" ]

func populate_seq():
	for itm in seq_item:
		seq_type.add_item(itm)
	fix_amnt_container(seq_type.get_selected_id())

func fix_amnt_container(id):
	amount_container.visible = (id > 4)

func seq_type_on_itm_selected(id):
	fix_amnt_container(id)

func on_btn_add_pressed():
	ammount_result = get_node(AmountTextPath).text.to_int()
	if amount_container.visible == false:
		ammount_result = -1
	
	var slectd = seq_type.get_selected_id()
	_parent.on_seq_list_item(seq_item[slectd], slectd, ammount_result)
	
	self.queue_free()

func _ready():
	seq_type = get_node(SeqTypePath)
	amount_container = get_node(AmountContainerPath)
	txtedt_seq_amnt = get_node(AmountTextPath)
	populate_seq()
	seq_type.connect("item_selected", self, "seq_type_on_itm_selected")
	
	get_node(btnAddPath).connect("pressed", self, "on_btn_add_pressed")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
