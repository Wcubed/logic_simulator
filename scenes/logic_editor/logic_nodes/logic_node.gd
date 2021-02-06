extends GraphNode

# Color of the in / outputs when they are off.
var _off_color := Color(0.5, 0.5, 0.5)
# Color of the in / outputs when they are on.
var _on_color := Color(1.0, 0.1, 0.1)


# Array of {"node": <String (node path)>, "state": <bool>}
# The node path is null if this one is not connected.
var _inputs := []
# Array of {"nodes": Array[<String (node path)>], "state": <bool>}
# The node path array is emtpy if nothing is connected.
var _outputs := []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_inputs() -> Array:
	# TODO: clone, so no-one messes with the inputs?
	return _inputs


func get_outputs() -> Array:
	# TODO: clone, so no-one messes with the outputs?
	return _outputs


func connect_input(idx: int, from: String):
	if idx < _inputs.size():
		_inputs[idx]["node"] = from


func connect_output(idx: int, to: String):
	if idx < _outputs.size():
		_outputs[idx]["nodes"].append(to)


func disconnect_input(idx: int):
	if idx < _inputs.size():
		_inputs[idx]["node"] = null


func disconnect_output(idx: int, to: String):
	if idx < _outputs.size():
		_outputs[idx]["nodes"].erase(to)


# TODO: Unit test this function.
func _set_input_amount(amount: int):
	# Make sure the input array is the correct size.
	if _inputs.size() < amount:
		for i in range(0, amount  - _inputs.size()):
			_inputs.append({"node": null, "state": false})
	else:
		_inputs.resize(amount)
	
	_update_child_amount()

# TODO: Unit test this function.
func _set_output_amount(amount: int):
	# Make sure the input array is the correct size.
	if _outputs.size() < amount:
		for i in range(0, amount  - _outputs.size()):
			_outputs.append({"nodes": [], "state": false})
	else:
		_outputs.resize(amount)
	
	_update_child_amount()

# Make sure there are the correct amount of children for the input and
# output nodes.
func _update_child_amount():
	var amount := max(_inputs.size(), _outputs.size())
	
	var child_count := get_child_count()
	if child_count < amount:
		for i in range(0, amount  - child_count):
			add_child(Label.new())
	else:
		# TODO: remove children.
		pass
	
	_update_slots()


func _set_input_state(idx: int, state: bool):
	if idx < _inputs.size():
		_inputs[idx]["state"] = state
		_update_slots()


func _set_output_state(idx: int, state: bool):
	if idx < _outputs.size():
		_outputs[idx]["state"] = state
		_update_slots()


func _update_slots():
	for i in get_child_count():
		var _input_color := _off_color
		var _input_used: bool = _inputs.size() > i
		
		if _input_used && _inputs[i]["state"]:
			_input_color = _on_color
		
		var _output_color := _off_color
		var _output_used: bool = _outputs.size() > i
		
		if _output_used && _outputs[i]["state"]:
			_output_color = _on_color
		
		set_slot(i, _input_used, 0, _input_color, _output_used, 0, _output_color)
