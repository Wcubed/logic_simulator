extends Object

signal node_added(id)
signal nodes_removed(ids)
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
# Does not contain the output node's state, as that one does not actually
# have any outputs itself.
var _graph_eval_state := {}

# Logic states of the output node (id == OUTPUT_ID).
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
# Also evaluates disconnected nodes and nodes that don't contribute to the
# overall graph output. As this graph might be displayed to the user at any
# time, and it needs to be consistent then.
# And graphs that will be re-used often will most likely not have many
# disconnected nodes in them.
func evaluate():
	# Remember the previous evaluation,
	# to use as input for evaluating looped nodes.
	var previous_eval_state := _graph_eval_state
	
	_graph_eval_state = {}
	_graph_eval_state[INPUT_ID] = _input_state
	
	_evaluate_node(OUTPUT_ID, previous_eval_state)
	
	# Now evaluate any node which does not directly contribute to the output.
	# e.g. the ones which have no outputs connected.
	# The recursive nature of the evaluate function will also evaluate
	# all the nodes "upstream" of these end-nodes.
	for id in _nodes.keys():
		var node: LogicNode = _nodes.get(id)
		
		var evaluate := true
		# Is any output in this node 
		for output in node.get_outputs():
			if output != []:
				evaluate = false
				break
		
		if evaluate:
			_evaluate_node(id, previous_eval_state)
	
	emit_signal("evaluated")


# Recursive function that evaluates the given logic node and all
# it's dependencies. Updates _graph_eval_state with it's findings.
# The previous_states dictionary is a copy of _graph_eval_state before it was
# cleared for this evaluation. Used as input when evaluating loops.
# The pending_nodes Dictionary is actaully a Set of id's, used to detect
# looped nodes.
func _evaluate_node(node_id: int, previous_states: Dictionary, pending_nodes: Dictionary = {}):
	pending_nodes[node_id] = null
	
	# TODO: detect loops?
	var node: LogicNode = _nodes[node_id]
	var inputs: Array = node.get_inputs()
	
	var input_states := []
	
	for input in inputs:
		if input == null:
			# Not connected, always false.
			input_states.append(false)
			continue
		
		var input_id: int = input["id"]
		var input_slot: int = input["slot"]
		var input_state := false
		
		if pending_nodes.has(input_id):
			# If the node is already pending it means we are in a loop.
			# To break the loop we will use that node's last output.
			var output_states: Array = previous_states.get(input_id, [])
			if output_states.size() > input_slot:
				input_state = output_states[input_slot]
		else:
			if not _graph_eval_state.has(input_id):
				_evaluate_node(input_id, previous_states, pending_nodes)
			# Now the given input state is available.
			input_state = _graph_eval_state[input_id][input_slot]
		
		input_states.append(input_state)
	
	if node_id == OUTPUT_ID:
		# Output node does not have outputs itself.
		_output_state = input_states
	else:
		var output := node.evaluate(input_states)
		_graph_eval_state[node_id] = output
	
	pending_nodes.erase(node_id)


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


func remove_nodes(ids: Array):
	var actually_removed := []
	
	for id in ids:
		if id == INPUT_ID or id == OUTPUT_ID:
			# Can't remove the in or output.
			continue
		
		var node: LogicNode = _nodes[id]
		var inputs := node.get_inputs()
		var outputs := node.get_outputs()
		
		for slot in inputs.size():
			if inputs[slot] != null:
				disconnect_nodes(inputs[slot]["id"], inputs[slot]["slot"], id, slot)
		for slot in outputs.size():
			for conn in outputs[slot]:
				disconnect_nodes(id, slot, conn["id"], conn["slot"])
	
		_nodes.erase(id)
		actually_removed.append(id)
	
	emit_signal("nodes_removed", actually_removed)


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
