extends "res://addons/gut/test.gd"


var LogicNode := load("res://data/logic_node.gd")

var _logic: Object = null


func before_each():
	_logic = autofree(LogicNode.new())


func test_new():
	assert_not_null(_logic)


func test_inputs_amount():
	_logic.set_inputs_amount(1)
	assert_eq(_logic.get_inputs_amount(), 1)
	
	_logic.set_inputs_amount(4)
	assert_eq(_logic.get_inputs_amount(), 4)
	
	_logic.set_inputs_amount(2)
	assert_eq(_logic.get_inputs_amount(), 2)
	
	_logic.set_inputs_amount(-10)
	assert_eq(_logic.get_inputs_amount(), 0)


func test_outputs_amount():
	_logic.set_outputs_amount(1)
	assert_eq(_logic.get_outputs_amount(), 1)
	
	_logic.set_outputs_amount(4)
	assert_eq(_logic.get_outputs_amount(), 4)
	
	_logic.set_outputs_amount(2)
	assert_eq(_logic.get_outputs_amount(), 2)
	
	_logic.set_outputs_amount(-10)
	assert_eq(_logic.get_outputs_amount(), 0)
