extends LogicNode


func _init():
	set_inputs_amount(2)
	set_outputs_amount(1)


func get_title() -> String:
	return "XOR"


func evaluate(input: Array) -> Array:
	return [input.count(true) == 1]


