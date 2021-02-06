extends GraphEdit



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _connect_logic_nodes(from: String, from_slot: int, to: String, to_slot: int):
	var from_node: GraphNode = get_node(from)
	var to_node: GraphNode = get_node(to)
	
	from_node.connect_output(from_slot, to)
	to_node.connect_input(to_slot, from)
	
	connect_node(from, from_slot, to, to_slot)


func _disconnect_logic_nodes(from: String, from_slot: int, to: String, to_slot: int):
	var from_node: GraphNode = get_node(from)
	var to_node: GraphNode = get_node(to)
	
	from_node.disconnect_output(from_slot, to)
	to_node.disconnect_input(to_slot)
	
	disconnect_node(from, from_slot, to, to_slot)


func _on_logic_editor_disconnection_request(from, from_slot, to, to_slot):
	_disconnect_logic_nodes(from, from_slot, to, to_slot)


func _on_logic_editor_connection_request(from, from_slot, to, to_slot):
	var to_node: GraphNode = get_node(to)
	var inputs: Array = to_node.get_inputs()
	
	if inputs.size() > to_slot:
		# Disallow connecting more than one output to an input.
		if inputs[to_slot]["node"] == null:
			_connect_logic_nodes(from, from_slot, to, to_slot)
