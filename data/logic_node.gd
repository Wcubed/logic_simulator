extends Object

class_name LogicNode

# Array of slots: [{"id": <id (int)>, "slot": <int>}]
# If slot not connected: null
# An input slot can only have one connection going into it.
var _inputs = []
# Array of slots and their connections: [[{"id": <id (int)>, "slot": <int>}]]
# If slot has no connections it has: `[]`
# An output can be connected to multiple inputs.
var _outputs = []


# Title of this node (for identification)
# Meant to be overridden by inheriting objects.
func get_title() -> String:
	return ""


# Call to evaluate this nodes logic.
# Should be overridden by inheriting objects.
# `input`: Array of `bool` with the state of the input connections.
#                should have the same size as `get_inputs_amount()`.
# `return`: Array of `bool` with the state of the outputs.
func evaluate(_input: Array) -> Array:
	return []


func set_inputs_amount(amount: int):
	amount = max(amount, 0)
	
	# TODO: disconnect from any nodes that were connected
	#       to any slots we will  remove.
	
	_inputs.resize(amount)


func set_outputs_amount(amount: int):
	amount = max(amount, 0)
	
	# TODO: disconnect from any nodes that were connected
	#       to any slots we will  remove.
	
	_outputs.resize(amount)
	
	# Outputs without connections get an empty list.
	for i in _outputs.size():
		if _outputs[i] == null:
			_outputs[i] = []


func get_inputs_amount() -> int:
	return _inputs.size()


func get_outputs_amount() -> int:
	return _outputs.size()


func connect_input(slot: int, node_id: int, other_slot: int):
	# TODO: in case this disconnects a node, let that node know?
	#       or will that get handled in the network handler?
	if slot >= get_inputs_amount():
		return
	
	_inputs[slot] = {"id": node_id, "slot": other_slot}


func disconnect_input(slot: int):
	# TODO: in case this disconnects a node, let that node know?
	#       or will that get handled in the network handler?
	if slot >= get_inputs_amount():
		return
	
	_inputs[slot] = null


func get_inputs() -> Array:
	return _inputs



func connect_output(slot: int, node_id: int, other_slot: int):
	if slot >= get_outputs_amount():
		return
	
	for conn in _outputs[slot]:
		if conn["id"] == node_id && conn["slot"] == other_slot:
			# Don't make the same connection twice.
			return
	
	_outputs[slot].append({"id": node_id, "slot": other_slot})


func disconnect_output(slot: int, node_id: int, other_slot: int):
	# TODO: in case this disconnects a node, let that node know?
	#       or will that get handled in the network handler?
	if slot >= get_outputs_amount():
		return
	
	var conns: Array = _outputs[slot]
	for i in conns.size():
		if conns[i]["id"] == node_id && conns[i]["slot"] == other_slot:
			conns.remove(i)
			break


func get_outputs() -> Array:
	return _outputs


# Returns a list with a label string for each input.
# May be overridden by sub classes.
func get_input_labels() -> Array:
	var labels := []
	for i in get_inputs_amount():
		labels.append("")
	return labels

# Returns a list with a label label for each input.
# May be overridden by sub classes.
func get_output_labels() -> Array:
	var labels := []
	for i in get_outputs_amount():
		labels.append("")
	return labels
