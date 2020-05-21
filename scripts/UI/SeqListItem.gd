extends GridContainer


export(NodePath) var LabelPath
export(NodePath) var RemoveButtonPath

var node_label:Label
var node_btn_rmv:TextureButton

func set_text(txt):
	node_label.text = txt

func get_btn_rmv():
	return node_btn_rmv


func _ready():
	node_label = get_node(LabelPath)
	node_btn_rmv = get_node(RemoveButtonPath)
