extends "res://addons/gut/test.gd"

var _graph: Object = null


func before_each():
	_graph = autofree(load("res://data/logic_graph.gd").new())


func test_new():
	assert_not_null(_graph)


func test_get_nodes():
	assert_eq(_graph.get_nodes(), [])
