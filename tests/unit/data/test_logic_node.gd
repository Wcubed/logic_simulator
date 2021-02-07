extends "res://addons/gut/test.gd"

var _logic: LogicNode = null


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


func test_connect_nonexistant_input():
	_logic.set_inputs_amount(1)
	# Slot `1` does not exist.
	_logic.connect_output(1, null, 0)
	
	assert_eq(_logic.get_inputs(), [null])


func test_connect_input():
	var other_logic := LogicNode.new()
	var other_slot := 2
	
	_logic.set_inputs_amount(1)
	_logic.connect_input(0, other_logic, other_slot)
	
	var inputs := _logic.get_inputs()
	assert_eq(inputs[0]["node"], other_logic)
	assert_eq(inputs[0]["slot"], other_slot)


func test_connect_nonexistant_output():
	_logic.set_outputs_amount(1)
	# Slot `1` does not exist.
	_logic.connect_output(1, null, 0)
	
	assert_eq(_logic.get_outputs(), [[]])


func test_connect_output():
	var other_logic := LogicNode.new()
	var other_slot := 2
	
	_logic.set_outputs_amount(1)
	_logic.connect_output(0, other_logic, other_slot)
	
	var outputs := _logic.get_outputs()
	assert_eq(outputs[0].size(), 1)
	assert_eq(outputs[0][0]["node"], other_logic)
	assert_eq(outputs[0][0]["slot"], other_slot)
	
	# Now make another distinct connection.
	other_slot = 1
	_logic.connect_output(0, other_logic, other_slot)
	
	outputs = _logic.get_outputs()
	assert_eq(outputs[0].size(), 2)
	assert_eq(outputs[0][1]["node"], other_logic)
	assert_eq(outputs[0][1]["slot"], other_slot)


func test_make_same_output_connection_twice():
	var other_logic := LogicNode.new()
	var other_slot := 2
	
	_logic.set_outputs_amount(1)
	_logic.connect_output(0, other_logic, other_slot)
	# The second call should have no effect as this connection is already made.
	_logic.connect_output(0, other_logic, other_slot)
	
	var outputs := _logic.get_outputs()
	assert_eq(outputs[0].size(), 1)
	assert_eq(outputs[0][0]["node"], other_logic)
	assert_eq(outputs[0][0]["slot"], other_slot)


func test_disconnect_input():
	var other_logic := LogicNode.new()
	var other_slot := 2
	
	_logic.set_inputs_amount(1)
	_logic.connect_input(0, other_logic, other_slot)
	
	_logic.disconnect_input(0)
	
	var inputs := _logic.get_inputs()
	assert_eq(inputs.size(), 1)
	assert_null(inputs[0])


func test_disconnect_output():
	var other_logic := LogicNode.new()
	var other_slot := 2
	
	_logic.set_outputs_amount(1)
	_logic.connect_output(0, other_logic, other_slot)
	
	_logic.disconnect_output(0, other_logic, other_slot)
	
	var outputs := _logic.get_outputs()
	assert_eq(outputs.size(), 1)
	assert_eq(outputs[0], [])
