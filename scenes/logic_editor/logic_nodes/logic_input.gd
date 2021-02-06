extends "res://scenes/logic_editor/logic_nodes/logic_node.gd"


onready var _checkbox: CheckBox = CheckBox.new()


func _ready():
	add_child(_checkbox)
	_checkbox.connect("toggled", self, "_on_Checkbox_toggled")
	
	title = "Input"
	
	_set_output_amount(1)


func _set_output_state(idx: int, state: bool):
	_checkbox.pressed = state
	
	._set_output_state(idx, state)



func _on_Checkbox_toggled(button_pressed: bool):
	_set_output_state(0, button_pressed)
