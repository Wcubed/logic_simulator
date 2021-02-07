extends "res://addons/gut/test.gd"

var _graph: Object = null


func before_each():
	_graph = autofree(load("res://data/logic_graph.gd").new())


func test_new():
	assert_not_null(_graph)


func test_get_nodes():
	# Input and output node.
	assert_eq(_graph.get_nodes().size(), 2)


func test_add_node():
	var node := LogicNode.new()
	
	var id: int = _graph.add_node(node)
	
	# Input and output id's are special.
	assert_ne(id, _graph.INPUT_ID)
	assert_ne(id, _graph.OUTPUT_ID)
	
	var nodes: Dictionary = _graph.get_nodes()
	# Input, output and the new node.
	assert_eq(nodes.size(), 3)
	assert_eq(nodes[id], node)


func test_remove_node():
	var node := LogicNode.new()
	
	var id: int = _graph.add_node(node)
	_graph.remove_node(id)
	
	assert_eq(_graph.get_nodes().size(), 2)
