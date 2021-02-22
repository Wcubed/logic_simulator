extends "res://addons/gut/test.gd"

var _graph: Object = null


func before_each():
	_graph = autofree(load("res://data/logic_graph.gd").new())


func test_new():
	assert_not_null(_graph)
	
	assert_eq(_graph.get_input_count(), 4)
	assert_eq(_graph.get_output_count(), 4)


func test_get_nodes():
	# Input and output node.
	assert_eq(_graph.get_nodes().size(), 2)


func test_add_node():
	watch_signals(_graph)
	
	var node := LogicNode.new()
	
	var id: int = _graph.add_node(node)
	
	assert_signal_emitted_with_parameters(_graph, "node_added", [id])
	
	# Input and output id's are special.
	assert_ne(id, _graph.INPUT_ID)
	assert_ne(id, _graph.OUTPUT_ID)
	
	var nodes: Dictionary = _graph.get_nodes()
	# Input, output and the new node.
	assert_eq(nodes.size(), 3)
	assert_eq(nodes[id], node)


func test_remove_node():
	watch_signals(_graph)
	var node := LogicNode.new()
	
	var id: int = _graph.add_node(node)
	_graph.remove_nodes([id])
	
	assert_signal_emitted_with_parameters(_graph, "node_removed", [id])
	assert_eq(_graph.get_nodes().size(), 2)
	
	# Should not be able to remove input and output.
	_graph.remove_nodes([_graph.INPUT_ID, _graph.OUTPUT_ID])
	assert_eq(_graph.get_nodes().size(), 2)


func test_no_connecting_to_same_input_twice():
	_graph.connect_nodes(_graph.INPUT_ID, 0, _graph.OUTPUT_ID, 0)
	_graph.connect_nodes(_graph.INPUT_ID, 1, _graph.OUTPUT_ID, 0)
	
	var input_node: LogicNode = _graph._input_node
	# Second output should not have connected.
	assert_eq(input_node.get_outputs()[1].size(), 0)
