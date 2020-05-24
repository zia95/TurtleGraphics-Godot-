extends Control


var seq_type : OptionButton
var amount_container : HBoxContainer

var seq_num_amnt : SpinBox

var amount_result : int

func get_amount():
	return amount_result

var _parent
func set_parent(prnt):
	self._parent = prnt

func set_seq_idx(seq_idx:int):
	if seq_idx >= 0:
		seq_type.select(seq_idx)
		fix_amnt_container(seq_idx)

func set_seq_amnt(seq_amnt:int):
	if seq_amnt > 0:
		seq_num_amnt.value = seq_amnt

onready var seq_item = TurtleSettings.get_turtle_cmd_str()

func populate_seq():
	for itm in seq_item:
		seq_type.add_item(itm)
	fix_amnt_container(seq_type.get_selected_id())

func fix_amnt_container(id):
	amount_container.visible = (id > 4)

func seq_type_on_itm_selected(id):
	fix_amnt_container(id)

func on_btn_add_pressed():
	#var node_amnt = $DisplayLayout/AmountContainer/NumAmount
	amount_result = seq_num_amnt.value
	var slectd = seq_type.get_selected_id()
	
	if amount_result <= 0 and TurtleSettings.turtle_cmd_takes_extra(slectd):
		$DisplayLayout/ButtonAdd/seq_invalid.play()
		return
	
	if amount_container.visible == false:
		amount_result = -1
	
	
	_parent.on_seq_list_item(slectd, amount_result)
	
	self.queue_free()

func _ready():
	seq_type = $DisplayLayout/OptionButton
	amount_container = $DisplayLayout/AmountContainer
	seq_num_amnt = $DisplayLayout/AmountContainer/NumAmount
	populate_seq()
	seq_type.connect("item_selected", self, "seq_type_on_itm_selected")
	
	$DisplayLayout/ButtonAdd.connect("pressed", self, "on_btn_add_pressed")
	

