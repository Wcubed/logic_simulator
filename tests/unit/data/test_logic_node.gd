extends "res://addons/gut/test.gd"


var LogicNode := load("res://data/logic_node.gd")

var _logic: Object = null


func before_each():
	_logic = LogicNode.new()


func test_new():
	assert_not_null(_logic)
