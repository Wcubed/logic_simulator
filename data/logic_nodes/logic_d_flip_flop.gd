extends LogicNode

var state := false
var last_clock := false


func _init():
	set_inputs_amount(2)
	set_outputs_amount(2)


func get_title() -> String:
	return "D FLIP FLOP"


# A D flip-flop takes on the value of the D input when the CLK input
# goes high (rising edge).
func evaluate(input: Array) -> Array:
	if !last_clock and input[1]:
		state = input[0]
	last_clock = input[1]
	
	return [state, not state]


func get_input_labels() -> Array:
	return ["D", "CLK"]


func get_output_labels() -> Array:
	return ["Q", "'Q"]
