
class_name TurtleSettings

enum TurtleCommands { 
	left, right, penup, pendown, 
	end_repeat, repeat, forward, 
	backward, rotation }

static func get_turtle_cmd_str():
	return [ "left", "right", "penup", "pendown","end repeat", "repeat", "forward", 
"backward", "rotation" ]

static func get_turtle_cmd_itm_text(idx, amnt):
	var seq = get_turtle_cmd_str()[idx]
	if amnt == -1:
		return ["-> ", seq]
	else:
		return [seq + " -> ", String(amnt)]
	

static func get_turtle_cmd_idx(cmd:String) -> int:
	var lst = get_turtle_cmd_str()
	for idx in range(lst.size()):
		if lst[idx] == cmd:
			return idx
	return -1


class TurtleCommand:
	var idx:int
	var cmd_idx:int
	var total_amnt:int
	var cmd_str:String
	
	#var lst_itm
	#var lst_itm_idx:int
	
	#run time settings
	
	var repeat_idx:int
	
	var amnt_rem:int
	
	func is_one_step():
		return !(cmd_idx == TurtleCommands.end_repeat or cmd_idx == TurtleCommands.forward or cmd_idx == TurtleCommands.backward)
	
	func do_repeat():
		if repeat_idx >= 0 and amnt_rem > 0:
			return repeat_idx
		else:
			return idx
	
	func get_amount_and_dec():
		amnt_rem -= 1
		if is_one_step():
			amnt_rem = 0
		return amnt_rem
	
	func reset():
		amnt_rem = total_amnt
	
	func is_finished():
		if amnt_rem > 0:
			return false
		return true
	

# convert seqlistitem object to turtlecommandclass
static func parse_commands(lst_itm_array):
	var repeat_idxs = []
	
	var itms = get_turtle_cmd_str()
	var itms_parsed = []
	
	for idx in range(lst_itm_array.size()):
		
		
		var cmd = lst_itm_array[idx]
		
		#assign
		var turtcls = TurtleCommand.new()
		turtcls.idx = idx
		turtcls.cmd_idx = cmd.get_cmd_idx()
		turtcls.total_amnt = cmd.get_cmd_amnt()
		turtcls.amnt_rem = turtcls.total_amnt
		turtcls.cmd_str = itms[turtcls.cmd_idx]
		
		#turtcls.lst_itm = cmd
		#turtcls.lst_itm_idx = cmd.get_idx()
		
		if turtcls.cmd_idx == TurtleCommands.repeat:
			repeat_idxs.push_back(idx)
		
		if turtcls.cmd_idx == TurtleCommands.end_repeat and repeat_idxs.size() > 0:
			turtcls.repeat_idx = repeat_idxs.pop_back()
			var rpt_tur = itms_parsed[turtcls.repeat_idx]
			
			rpt_tur.total_amnt += 1 # system starts with 1 not 0 so we have to increment.
			rpt_tur.amnt_rem = rpt_tur.total_amnt
			turtcls.total_amnt = rpt_tur.total_amnt
			turtcls.amnt_rem = rpt_tur.total_amnt
		
		itms_parsed.push_back(turtcls)
		
	
	if repeat_idxs.size() != 0:
		return null
	return itms_parsed
