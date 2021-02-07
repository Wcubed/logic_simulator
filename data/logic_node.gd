extends Object

class_name LogicNode

# Array of slots: [{"node": <LogicNode>, "slot": <int>}]
# If slot not connected: null
# An input slot can only have one connection going into it.
var _inputs = []
# Array of slots and their connections: [[{"node": <LogicNode>, "slot": <int>}]]
# If slot has no connections it has: `[]`
# An output can be connected to multiple inputs.
var _outputs = []
# Boolean values for the current output states.
var _outputs_state = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Call to evaluate this nodes logic and update its outputs_state.
# Should be overridden by inheriting objects.
func evaluate():
	pass


# Evaluates the input connections and returns the current status.
func _get_inputs_state() -> Array:
	var state := []
	for i in get_inputs_amount():
		state.append(false)
	
	for i in state.size():
		if _inputs[i] != null:
			var other: LogicNode = _inputs[i]["node"]
			state[i] = other.get_output_state(_inputs[i]["slot"])
	
	return state


# Get's the current state of the output slots.
# If the given slot does not exist, it always returns false.
func get_output_state(slot: int) -> bool:
	if slot >= get_outputs_amount() || slot < 0:
		return false
	else:
		return _outputs_state[slot]


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
	_outputs_state.resize(amount)
	
	# Outputs without connections get an empty list.
	for i in _outputs.size():
		if _outputs[i] == null:
			_outputs[i] = []
	
	# Default output state = false.
	for i in _outputs_state.size():
		if _outputs_state[i] == null:
			_outputs_state[i] = false


func get_inputs_amount() -> int:
	return _inputs.size()


func get_outputs_amount() -> int:
	return _outputs.size()


func connect_input(slot: int, node: LogicNode, other_slot: int):
	# TODO: in case this disconnects a node, let that node know?
	#       or will that get handled in the network handler?
	if slot >= get_inputs_amount():
		return
	
	_inputs[slot] = {"node": node, "slot": other_slot}


func disconnect_input(slot: int):
	# TODO: in case this disconnects a node, let that node know?
	#       or will that get handled in the network handler?
	if slot >= get_inputs_amount():
		return
	
	_inputs[slot] = null


func get_inputs() -> Array:
	return _inputs


func connect_output(slot: int, node: LogicNode, other_slot: int):
	if slot >= get_outputs_amount():
		return
	
	for conn in _outputs[slot]:
		if conn["node"] == node && conn["slot"] == other_slot:
			# Don't make the same connection twice.
			return
	
	_outputs[slot].append({"node": node, "slot": other_slot})


func disconnect_output(slot: int, node: LogicNode, other_slot: int):
	# TODO: in case this disconnects a node, let that node know?
	#       or will that get handled in the network handler?
	if slot >= get_outputs_amount():
		return
	
	var conns: Array = _outputs[slot]
	for i in conns.size():
		if conns[i]["node"] == node && conns[i]["slot"] == other_slot:
			conns.remove(i)
			break


func get_outputs() -> Array:
	return _outputs
