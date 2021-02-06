extends WATTest

var _scene := load("res://scenes/logic_editor/logic_nodes/logic_node.tscn")
var _script := load("res://scenes/logic_editor/logic_nodes/logic_input.gd")

var _input_node: Node = null


func start():
	_input_node = _scene.instance()
	_input_node.set_script(_script)
	add_child(_input_node)


func end():
	_input_node.free()


func test_instantiation():
	asserts.is_not_null(_input_node)


func test_output_toggle():
	asserts.is_false(_input_node.get_output_state())
	_input_node.set_output_state(true)
	asserts.is_true(_input_node.get_output_state())
