extends "res://addons/gut/test.gd"

var _node: LogicNode = null


func before_each():
	_node = autofree(load("res://data/logic_nodes/logic_or.gd").new())


func test_new():
	assert_not_null(_node)
	
	assert_eq(_node.get_inputs_amount(), 2)
	assert_eq(_node.get_outputs_amount(), 1)


func test_evaluate():
	assert_eq(_node.evaluate([false, false]), [false])
	assert_eq(_node.evaluate([false, true]), [true])
	assert_eq(_node.evaluate([true, false]), [true])
	assert_eq(_node.evaluate([true, true]), [true])
