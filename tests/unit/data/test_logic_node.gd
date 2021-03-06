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


func test_connect_nonexistent_input():
	_logic.set_inputs_amount(1)
	# Slot `1` does not exist.
	_logic.connect_output(1, 0, 0)
	
	assert_eq(_logic.get_inputs(), [null])


func test_connect_input():
	var other_id := 12
	var other_slot := 2
	
	_logic.set_inputs_amount(1)
	_logic.connect_input(0, other_id, other_slot)
	
	var inputs := _logic.get_inputs()
	assert_eq(inputs[0]["id"], other_id)
	assert_eq(inputs[0]["slot"], other_slot)


func test_connect_nonexistent_output():
	_logic.set_outputs_amount(1)
	# Slot `1` does not exist.
	_logic.connect_output(1, 2, 0)
	
	assert_eq(_logic.get_outputs(), [[]])


func test_connect_output():
	var other_id := 13
	var other_slot := 2
	
	_logic.set_outputs_amount(1)
	_logic.connect_output(0, other_id, other_slot)
	
	var outputs := _logic.get_outputs()
	assert_eq(outputs[0].size(), 1)
	assert_eq(outputs[0][0]["id"], other_id)
	assert_eq(outputs[0][0]["slot"], other_slot)
	
	# Now make another distinct connection.
	other_slot = 1
	_logic.connect_output(0, other_id, other_slot)
	
	outputs = _logic.get_outputs()
	assert_eq(outputs[0].size(), 2)
	assert_eq(outputs[0][1]["id"], other_id)
	assert_eq(outputs[0][1]["slot"], other_slot)


func test_make_same_output_connection_twice():
	var other_id := -13
	var other_slot := 2
	
	_logic.set_outputs_amount(1)
	_logic.connect_output(0, other_id, other_slot)
	# The second call should have no effect as this connection is already made.
	_logic.connect_output(0, other_id, other_slot)
	
	var outputs := _logic.get_outputs()
	assert_eq(outputs[0].size(), 1)
	assert_eq(outputs[0][0]["id"], other_id)
	assert_eq(outputs[0][0]["slot"], other_slot)


func test_disconnect_input():
	var other_id := 136
	var other_slot := 2
	
	_logic.set_inputs_amount(1)
	_logic.connect_input(0, other_id, other_slot)
	
	_logic.disconnect_input(0)
	
	var inputs := _logic.get_inputs()
	assert_eq(inputs.size(), 1)
	assert_null(inputs[0])


func test_disconnect_output():
	var other_id := 1827
	var other_slot := 2
	
	_logic.set_outputs_amount(1)
	_logic.connect_output(0, other_id, other_slot)
	
	_logic.disconnect_output(0, other_id, other_slot)
	
	var outputs := _logic.get_outputs()
	assert_eq(outputs.size(), 1)
	assert_eq(outputs[0], [])


func test_get_input_labels():
	var labels: Array = _logic.get_input_labels()
	assert_eq(labels.size(), 0)
	
	_logic.set_inputs_amount(2)
	
	labels = _logic.get_input_labels()
	assert_eq(labels.size(), 2)
	assert_eq(labels[0], "")
	assert_eq(labels[1], "")

func test_get_output_labels():
	var labels: Array = _logic.get_output_labels()
	assert_eq(labels.size(), 0)
	
	_logic.set_outputs_amount(3)
	
	labels = _logic.get_output_labels()
	assert_eq(labels.size(), 3)
	assert_eq(labels[0], "")
	assert_eq(labels[1], "")
	assert_eq(labels[2], "")
