extends GraphNode

# Color of the in / outputs when they are off.
var _off_color := Color(0.5, 0.5, 0.5)
# Color of the in / outputs when they are on.
var _on_color := Color(1.0, 0.1, 0.1)


var _input_state := []
var _output_state := [false]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _set_input_state(state: Array):
	_input_state = state
	_update_slots()


func _set_output_state(state: Array):
	_output_state = state
	_update_slots()


func _update_slots():
	for i in get_child_count():
		var _input_color := _off_color
		var _input_used: bool = _input_state.size() > i
		
		if _input_used && _input_state[i]:
			_input_color = _on_color
		
		var _output_color := _off_color
		var _output_used: bool = _output_state.size() > i
		
		if _output_used && _output_state[i]:
			_output_color = _on_color
		
		set_slot(i, _input_used, 0, _input_color, _output_used, 0, _output_color)
