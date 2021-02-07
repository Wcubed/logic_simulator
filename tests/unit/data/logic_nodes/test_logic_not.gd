extends "res://addons/gut/test.gd"

var _not: LogicNode = null


func before_each():
	_not = autofree(load("res://data/logic_nodes/logic_not.gd").new())


func test_new():
	assert_not_null(_not)
	
	assert_eq(_not.get_inputs_amount(), 1)
	assert_eq(_not.get_outputs_amount(), 1)


func test_evaluate():
	assert_eq(_not.evaluate([false]), [true])
	assert_eq(_not.evaluate([true]), [false])
