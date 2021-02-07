extends Object

# Array of slots: {"object": <logic_node>, "slot": <int>}
# If slot not connected: null
# An input slot can only have one connection going into it.
var _inputs = []
# Array of slots and their connections: {<logic_node>: <slot (int)>, <other_node>: <slot (int)>}
# If slot has no connections: null
# An output can be connected to multiple inputs.
var _outputs = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_inputs_amount(amount: int):
	amount = max(amount, 0)
	
	# TODO: disconnect from any nodes that were connected
	#       to any slots we will  remove.
	
	_inputs.resize(amount)


func set_outputs_amount(amount: int):
	amount = max(amount, 0)
	
	# TODO: disconnect from any nodes that were connected
	#       to any slots we will  remove.
	
	_outputs.resize(amount)


func get_inputs_amount() -> int:
	return _inputs.size()


func get_outputs_amount() -> int:
	return _outputs.size()
