extends LogicNode


func _init():
	set_inputs_amount(1)
	set_outputs_amount(1)


func evaluate(input: Array) -> Array:
	return [not input[0]]
