extends "res://scenes/logic_editor/logic_nodes/logic_node.gd"



func _ready():	
	title = "AND"
	
	add_child(Label.new())
	add_child(Label.new())
	
	_set_input_state([false, false])
	_set_output_state([false])
