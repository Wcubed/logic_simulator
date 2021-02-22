extends "res://addons/gut/test.gd"

var And := load("res://data/logic_nodes/logic_and.gd")
var Not := load("res://data/logic_nodes/logic_not.gd")

var _graph: Object = null


func before_each():
	_graph = autofree(load("res://data/logic_graph.gd").new())


func test_connect_and_disconnect_nodes():
	watch_signals(_graph)
	
	var and_node: LogicNode = And.new()
	var not_node: LogicNode = Not.new()
	
	var and_id: int = _graph.add_node(and_node)
	var not_id: int = _graph.add_node(not_node)
	
	_graph.connect_nodes(and_id, 0, not_id, 0)
	assert_signal_emitted_with_parameters(_graph, "nodes_connected", [and_id, 0, not_id, 0])
	
	var and_outputs = and_node.get_outputs()
	var not_inputs = not_node.get_inputs()
	
	assert_eq(and_outputs[0][0]["id"], not_id,  "test")
	assert_eq(and_outputs[0][0]["slot"], 0)
	
	assert_eq(not_inputs[0]["id"], and_id)
	assert_eq(not_inputs[0]["slot"], 0)
	
	_graph.disconnect_nodes(and_id, 0, not_id, 0)
	assert_signal_emitted_with_parameters(_graph, "nodes_disconnected", [and_id, 0, not_id, 0])
	
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


func test_simple_evaluate():
	watch_signals(_graph)
	
	_graph.connect_nodes(_graph.INPUT_ID, 0, _graph.OUTPUT_ID, 0)
	
	_graph.set_input_state(0, true)
	_graph.evaluate()
	assert_signal_emitted(_graph, "evaluated")
	assert_true(_graph.get_output_state()[0])
	
	var eval_state: Dictionary = _graph.get_eval_state()
	# Check if the eval state works.
	# (the output node will not be in here, which is why we test the input node)
	assert_true(eval_state[_graph.INPUT_ID][0])
	
	_graph.set_input_state(0, false)
	_graph.evaluate()
	assert_false(_graph.get_output_state()[0])


var _more_complex_eval_params = [
	[false, false, false],
	[false, true, true],
	[true, false, false],
	[true, true, false]]
func test_more_complex_evaluation(params=use_parameters(_more_complex_eval_params)):
	var and_node: LogicNode = And.new()
	var not_node: LogicNode = Not.new()
	
	var and_id: int = _graph.add_node(and_node)
	var not_id: int = _graph.add_node(not_node)
	
	_graph.connect_nodes(_graph.INPUT_ID, 0, not_id, 0)
	_graph.connect_nodes(not_id, 0, and_id, 0)
	_graph.connect_nodes(_graph.INPUT_ID, 1, and_id, 1)
	_graph.connect_nodes(and_id, 0, _graph.OUTPUT_ID, 0)
	
	_graph.set_input_state(0, params[0])
	_graph.set_input_state(1, params[1])
	
	_graph.evaluate()
	
	assert_eq(_graph.get_output_state()[0], params[2])


# Evaluating the graph should also consider nodes which outputs do not
# connect to anything, (even when hidden)
# as the graph might need to be displayed to the user at any time.
# And then the state then needs to be consistent.
func test_disconnected_node_evaluation():
	var not_node: LogicNode = Not.new()
	
	var not_id: int = _graph.add_node(not_node)
	
	_graph.evaluate()
	
	var output_state: Dictionary = _graph.get_eval_state()
	
	assert_has(output_state, not_id)
	assert_eq(output_state.get(not_id)[0], true)
