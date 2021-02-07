extends LogicNode


func _init():
	set_inputs_amount(2)
	set_outputs_amount(1)


func evaluate():
	var input := _get_inputs_state()
	
	# Logic AND
	_outputs_state[0] = (input.find(false) == -1)
