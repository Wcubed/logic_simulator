extends LogicNode


func _init():
	set_inputs_amount(2)
	set_outputs_amount(1)


func get_title() -> String:
	return "NAND"


func evaluate(input: Array) -> Array:
	# Logic AND
	return [input.find(false) != -1]
