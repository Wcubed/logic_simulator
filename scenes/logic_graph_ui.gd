extends GraphEdit


var logic_node_scene := preload("logic_node_ui.tscn")

var _graph: Object = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Sets this graph ui up to display the state of the given graph.
func display_graph(graph: Object):
	_graph = graph
	
	for child in get_children():
		if child is GraphNode:
			child.free()
	
	var nodes: Dictionary = _graph.get_nodes()
	for key in nodes.keys():
		_create_node(key, nodes[key])
	
	# TODO: show any connection that already exists.


# Creates a visual counterparts of a LogicNode.
func _create_node(id: int, node: LogicNode):
	var new_node := logic_node_scene.instance()
	new_node.name = str(id)
	
	add_child(new_node)
	new_node.update_title(node.get_title())
	new_node.update_input_output_amounts(node)


func _on_LogicGraphUi_connection_request(from: String, from_slot: int, to: String, to_slot: int):
	_graph.connect_nodes(int(from), from_slot, int(to), to_slot)
