extends "res://addons/gut/test.gd"

var _and: LogicNode = null


func before_each():
	_and = autofree(load("res://data/logic_nodes/logic_and.gd").new())


func test_new():
	assert_not_null(_and)
	
	assert_eq(_and.get_inputs_amount(), 2)
	assert_eq(_and.get_outputs_amount(), 1)


func test_evaluate():
	assert_eq(_and.evaluate([false, false]), [false])
	assert_eq(_and.evaluate([false, true]), [false])
	assert_eq(_and.evaluate([true, false]), [false])
	assert_eq(_and.evaluate([true, true]), [true])
