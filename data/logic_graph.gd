extends Object

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


func _init():
	_input_node = LogicNode.new()
	_output_node = LogicNode.new()
	
	_input_node.set_outputs_amount(4)
	_output_node.set_inputs_amount(4)
	
	_nodes[INPUT_ID] = _input_node
	_nodes[OUTPUT_ID] = _output_node


func get_nodes():
	return _nodes


# Adds a new node to the graph.
# The node should not already be in the graph (not enforced, but causes issues).
# `return`: The id of the node.
func add_node(node: LogicNode) -> int:
	var id := _next_id 
	_next_id += 1
	
	_nodes[id] = node
	
	return id


func remove_node(id: int):
	# TODO: remove connections to and from this node.
	
	if id == INPUT_ID or id == OUTPUT_ID:
		# Can't remove the in or output.
		return
	
	_nodes.erase(id)


# Connect the output slot of the first node, to the input slot of the second node.
# Does nothing if either a node does not exist, or one of the slots does not exist.
func connect_nodes(first_id: int, output_slot: int, second_id: int, input_slot):
	var first_node: LogicNode = _nodes.get(first_id)
	var second_node: LogicNode = _nodes.get(second_id)
	
	if first_node == null or second_node == null:
		return
	if first_node.get_outputs_amount() <= output_slot and second_node.get_inputs_amount() <= input_slot:
		return
	
	first_node.connect_output(output_slot, second_id, input_slot)
	second_node.connect_input(input_slot, first_id, output_slot)


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
