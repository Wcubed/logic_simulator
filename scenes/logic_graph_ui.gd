extends HSplitContainer


var logic_node_scene := preload("logic_node_ui.tscn")

var _graph: Object = null

onready var _graph_edit := $GraphEdit
onready var _input_buttons := $VBoxContainer/InputButtons
onready var _output_lights := $VBoxContainer/OutputLights

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Sets this graph ui up to display the state of the given graph.
func display_graph(graph: Object):
	if _graph != null:
		_graph.disconnect("nodes_connected", self, "_on_graph_nodes_connected")
		_graph.disconnect("nodes_disconnected", self, "_on_graph_nodes_disconnected")
		_graph.disconnect("evaluated", self, "_on_graph_evaluated")
	
	_graph = graph
	
	_graph.connect("nodes_connected", self, "_on_graph_nodes_connected")
	_graph.connect("nodes_disconnected", self, "_on_graph_nodes_disconnected")
	_graph.connect("evaluated", self, "_on_graph_evaluated")
	
	for child in _graph_edit.get_children():
		if child is GraphNode:
			child.free()
	
	for child in _input_buttons.get_children():
		child.disconnect("toggled", self, "_on_input_button_toggle")
		child.free()
	
	for child in _output_lights.get_children():
		child.free()
	
	
	var nodes: Dictionary = _graph.get_nodes()
	for key in nodes.keys():
		_create_node(key, nodes[key])
	
	for i in _graph.get_input_count():
		var input := CheckBox.new()
		input.connect("toggled", self, "_on_input_button_toggle", [i])
		_input_buttons.add_child(input)
	
	for i in _graph.get_output_count():
		var output := CheckBox.new()
		output.disabled = true
		_output_lights.add_child(output)
	
	# TODO: show any connection that already exists.


# Creates a visual counterparts of a LogicNode.
func _create_node(id: int, node: LogicNode):
	var new_node := logic_node_scene.instance()
	new_node.name = str(id)
	
	_graph_edit.add_child(new_node)
	new_node.update_title(node.get_title())
	new_node.update_input_output_amounts(node)


func _update_node_input_output_state(id: int, graph_state: Dictionary):
	var logic_nodes: Dictionary = _graph.get_nodes()
	
	var ui_node := _graph_edit.get_node(String(id))
	var logic_node: LogicNode = logic_nodes[id]
	var inputs := logic_node.get_inputs()
	
	var input_state := []
	for input in inputs:
		var state := false
		if input != null:
			state = graph_state[input["id"]][input["slot"]]
		
		input_state.append(state)
	
	ui_node.update_input_output_state(input_state, graph_state.get(id, []))


func _on_graph_nodes_connected(from: int, from_slot: int, to: int, to_slot: int):
	_graph_edit.connect_node(String(from), from_slot, String(to), to_slot)


func _on_graph_nodes_disconnected(from: int, from_slot: int, to: int, to_slot: int):
	_graph_edit.disconnect_node(String(from), from_slot, String(to), to_slot)


func _on_graph_evaluated():
	# Update the output lights.
	var output: Array = _graph.get_output_state()
	for i in _output_lights.get_child_count():
		_output_lights.get_child(i).pressed = output[i]
	
	# Update the nodes.
	# TODO: update the inputs of the nodes.
	var graph_state: Dictionary = _graph.get_eval_state()
	
	for key in graph_state.keys():
		_update_node_input_output_state(key, graph_state)
	
	# Output node is not in the graph_state, because that only lists node
	# output states, and the output node does actually not have outputs.
	_update_node_input_output_state(_graph.OUTPUT_ID, graph_state)
	
	# Update the graph line visuals.
	# They don't update automatically, until the graph is moved / resized or
	# one of it's graph nodes is moved.
	# They even don't update automatically if `low-cpu-mode` is off.
	_graph_edit.get_node("CLAYER").update()


func _on_GraphEdit_connection_request(from: String, from_slot: int, to: String, to_slot: int):
	_graph.connect_nodes(int(from), from_slot, int(to), to_slot)
	_graph.evaluate()


func _on_GraphEdit_disconnection_request(from: String, from_slot: int, to: String, to_slot: int):
	_graph.disconnect_nodes(int(from), from_slot, int(to), to_slot)
	_graph.evaluate()


func _on_input_button_toggle(state: bool, id: int):
	_graph.set_input_state(id, state)
	_graph.evaluate()
