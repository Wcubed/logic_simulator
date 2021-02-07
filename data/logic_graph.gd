extends Object

# A dictionary of id -> LogicNode.
var _nodes := {}

# Keep track of the next id to use for a new node.
var _next_id := 0


func get_nodes():
	return _nodes


# Adds a new node to the graph.
# The node should not already be in the graph (not enforced, but causes issues).
# `return`: The id of the node.
func add_node(node: LogicNode) -> int:
	var id := _next_id 
	_next_id += 1
	
	_nodes[id] = node
	
	return id


func remove_node(id: int):
	# TODO: remove connections to and from this node.
	
	_nodes.erase(id)
