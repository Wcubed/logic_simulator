extends "res://addons/gut/test.gd"


var _store: Object = null


func before_each():
	_store = autofree(load("res://data/logic_node_store.gd").new())


func test_new():
	assert_not_null(_store)
	
	assert_eq(_store.get_logic_nodes().size(), 0)

# TODO: Create a resource folder with mock nodes that we can load
#       to test the various failure modes.

func test_loaded_all_default_logic_nodes():
	_store.load_logic_nodes("res://data/logic_nodes/")
	var nodes: Dictionary = _store.get_logic_nodes()
	
	assert_eq(nodes.size(), 3)
	
	# Check if it actually adheres to the titles.
	assert_eq(nodes["NOT"].new().get_title(), "NOT")
