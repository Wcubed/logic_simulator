# Special node where the user (or an overarching block) can input state into the graph.
extends LogicNode


func _init():
	# TODO: allow some nodes to have a variable amount of inputs  / outputs.
	#       maybe limited by "max inputs" and "max outputs"?
	set_outputs_amount(4)


func evaluate(input: Array) -> Array:
	assert("You cannot `evaluate` a logic_input.")
	return []
