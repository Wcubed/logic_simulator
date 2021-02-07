extends Object

signal node_added(id)
signal nodes_connected(from_id, from_slot, to_id, to_slot)
signal nodes_disconnected(from_id, from_slot, to_id, to_slot)
signal evaluated()

# Node ids for the input and output nodes, which always exist.
# Each graph has exactly 1.
const INPUT_ID := 0
const OUTPUT_ID := 1

# A dictionary of id -> LogicNode.
var _nodes := {}

# Keep track of the next id to use for a new node.
var _next_id := OUTPUT_ID + 1


var _input_node: LogicNode = null
var _output_node: LogicNode = null

var _input_state := [false, false, false, false]
# Dictionary of node id's to their list of output states.
# Get's updated after `evaluate()` is called.
var _graph_eval_state := {}
# Updated once `evaluate()` is called.
var _output_state := []


func _init():
	_input_node = LogicNode.new()
	_output_node = LogicNode.new()
	
	# TODO: allow changing input and output amount.
	_input_node.set_outputs_amount(4)
	_output_node.set_inputs_amount(4)
	
	_nodes[INPUT_ID] = _input_node
	_nodes[OUTPUT_ID] = _output_node


func set_input_state(slot: int, state: bool):
	if slot < _input_state.size():
		_input_state[slot] = state


# Returns the graphs output state.
# Returns an empty array if the graph has not been evaluated.
func get_output_state() -> Array:
	return _output_state


func get_input_count():
	return _nodes[INPUT_ID].get_outputs_amount()


func get_output_count():
	return _nodes[OUTPUT_ID].get_inputs_amount()


# Returns the evaluated state.
# Returns an empty dictionary when the graph has not been evaluated yet.
func get_eval_state() -> Dictionary:
	return _graph_eval_state


# Evaluates the graph and records each node's output states in _graph_eval_state
func evaluate():
	# Todo: evaluate branches that do not end up at the output?
	#       only if the graph is actually shown to the user?
	#       otherwise there is no need to evaluate dead ends.
	_graph_eval_state = {}
	_graph_eval_state[INPUT_ID] = _input_state
	
	_evaluate_node(OUTPUT_ID)
	
	emit_signal("evaluated")


# Recursive function that evaluates the given logic node and all
# it's dependencies. Updates _graph_eval_state with it's findings.
func _evaluate_node(node_id: int):
	# TODO: detect loops?
	#       is it even necessary to detect loops?
	var node: LogicNode = _nodes[node_id]
	var inputs: Array = node.get_inputs()
	
	var input_states := []
	
	for input in inputs:
		if input == null:
			# Not connected, always false.
			input_states.append(false)
			continue
		
		var input_id: int = input["id"]
		
		if not _graph_eval_state.has(input_id):
			_evaluate_node(input_id)
		# Now the given input state is available.
		var input_state: bool = _graph_eval_state[input_id][input["slot"]]
		input_states.append(input_state)
	
	if node_id == OUTPUT_ID:
		# Output node does not have outputs itself.
		_output_state = input_states
	else:
		var output := node.evaluate(input_states)
		_graph_eval_state[node_id] = output


func get_nodes():
	return _nodes


# Adds a new node to the graph.
# The node should not already be in the graph (not enforced, but causes issues).
# `return`: The id of the node.
func add_node(node: LogicNode) -> int:
	var id := _next_id 
	_next_id += 1
	
	_nodes[id] = node
	emit_signal("node_added", id)
	
	return id


func remove_node(id: int):
	# TODO: remove connections to and from this node.
	
	if id == INPUT_ID or id == OUTPUT_ID:
		# Can't remove the in or output.
		return
	
	_nodes.erase(id)


# Connect the output slot of the first node, to the input slot of the second node.
# Does nothing if either a node does not exist, one of the slots does not exist,
# or the input slot does already have a connection.
func connect_nodes(first_id: int, output_slot: int, second_id: int, input_slot):
	var first_node: LogicNode = _nodes.get(first_id)
	var second_node: LogicNode = _nodes.get(second_id)
	
	if first_node == null or second_node == null:
		return
	if first_node.get_outputs_amount() <= output_slot and second_node.get_inputs_amount() <= input_slot:
		# One of the slots does not exist.
		return
	if second_node.get_inputs()[input_slot] != null:
		# The given input slot is already connected.
		return
	
	first_node.connect_output(output_slot, second_id, input_slot)
	second_node.connect_input(input_slot, first_id, output_slot)
	
	emit_signal("nodes_connected", first_id, output_slot, second_id, input_slot)




func disconnect_nodes(first_id: int, output_slot: int, second_id: int, input_slot):
	var first_node: LogicNode = _nodes.get(first_id)
	var second_node: LogicNode = _nodes.get(second_id)
	
	if first_node == null or second_node == null:
		return
	
	var input_connection = second_node.get_inputs()[input_slot]
	if input_connection["id"] != first_id or input_connection["slot"] != output_slot:
		# The connection does not exist.
		# We do not need to check the output node for a connection, because
		# that can have multiple, and won't do anything when we disconnect a
		# nonexistent connection.
		return
	
	first_node.disconnect_output(output_slot, second_id, input_slot)
	second_node.disconnect_input(input_slot)
	
	emit_signal("nodes_disconnected", first_id, output_slot, second_id, input_slot)
