extends "res://addons/gut/test.gd"

var InputNode := load("res://data/logic_nodes/logic_input.gd")
var And := load("res://data/logic_nodes/logic_and.gd")
var Not := load("res://data/logic_nodes/logic_not.gd")

var _graph: Object = null


func before_each():
	_graph = autofree(load("res://data/logic_graph.gd").new())


func test_connect_and_disconnect_nodes():
	var and_node: LogicNode = And.new()
	var not_node: LogicNode = Not.new()
	
	var and_id: int = _graph.add_node(and_node)
	var not_id: int = _graph.add_node(not_node)
	
	_graph.connect_nodes(and_id, 0, not_id, 0)
	
	var and_outputs = and_node.get_outputs()
	var not_inputs = not_node.get_inputs()
	
	assert_eq(and_outputs[0][0]["id"], not_id,  "test")
	assert_eq(and_outputs[0][0]["slot"], 0)
	
	assert_eq(not_inputs[0]["id"], and_id)
	assert_eq(not_inputs[0]["slot"], 0)
	
	_graph.disconnect_nodes(and_id, 0, not_id, 0)
	
	assert_eq(and_outputs[0].size(), 0)
	assert_eq(not_inputs[0], null)


func test_connect_and_disconnect_from_input():
	var not_node: LogicNode = Not.new()
	var not_id: int = _graph.add_node(not_node)
	
	_graph.connect_nodes(_graph.INPUT_ID, 0, not_id, 0)
	
	var not_inputs = not_node.get_inputs()
	
	assert_eq(not_inputs[0]["id"], _graph.INPUT_ID)
	assert_eq(not_inputs[0]["slot"], 0)
	
	_graph.disconnect_nodes(_graph.INPUT_ID, 0, not_id, 0)
	
	assert_eq(not_inputs[0], null)


func test_connect_and_disconnect_to_output():
	var not_node: LogicNode = Not.new()
	var not_id: int = _graph.add_node(not_node)
	
	_graph.connect_nodes(not_id, 0, _graph.OUTPUT_ID, 0)
	
	var not_outputs = not_node.get_outputs()
	
	assert_eq(not_outputs[0][0]["id"], _graph.OUTPUT_ID)
	assert_eq(not_outputs[0][0]["slot"], 0)
	
	_graph.disconnect_nodes(not_id, 0, _graph.OUTPUT_ID, 0)
	
	assert_eq(not_outputs[0], [])
