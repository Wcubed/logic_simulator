extends "res://addons/gut/test.gd"

var _node: LogicNode = null


func before_each():
	_node = autofree(load("res://data/logic_nodes/logic_d_flip_flop.gd").new())


func test_new():
	assert_not_null(_node)
	
	assert_eq(_node.get_inputs_amount(), 2)
	assert_eq(_node.get_outputs_amount(), 2)


func test_evaluate():
	# D flip-flop should take the D input when the CLK output rises.
	assert_eq(_node.evaluate([false, false]), [false, true])
	assert_eq(_node.evaluate([true, true]), [true, false])
	assert_eq(_node.evaluate([true, false]), [true, false])
	assert_eq(_node.evaluate([false, true]), [false, true])
	assert_eq(_node.evaluate([true, false]), [false, true])
	assert_eq(_node.evaluate([true, true]), [true, false])
	assert_eq(_node.evaluate([false, true]), [true, false])
	assert_eq(_node.evaluate([true, false]), [true, false])
	assert_eq(_node.evaluate([false, true]), [false, true])
