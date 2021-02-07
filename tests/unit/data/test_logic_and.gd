extends "res://addons/gut/test.gd"

var _and: LogicNode = null


func before_each():
	_and = autofree(load("res://data/logic_and.gd").new())


func test_new():
	assert_not_null(_and)
	
	assert_eq(_and.get_inputs_amount(), 2)
	assert_eq(_and.get_outputs_amount(), 1)


func test_evaluate_without_connections():
	_and.evaluate()
	
	assert_false(_and.get_output_state(0))


func test_evaluate_with_connections():
	var other_logic := LogicNode.new()
	other_logic.set_outputs_amount(2)
	
	_and.connect_input(0, other_logic, 0)
	_and.connect_input(1, other_logic, 1)
	
	_and.evaluate()
	assert_false(_and.get_output_state(0))
	
	other_logic._outputs_state = [true, true]
	_and.evaluate()
	assert_true(_and.get_output_state(0))
