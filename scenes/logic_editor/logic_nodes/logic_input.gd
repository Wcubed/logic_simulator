extends "res://scenes/logic_editor/logic_nodes/logic_node.gd"


var _output_state := false setget set_output_state, get_output_state


onready var _checkbox: CheckBox = CheckBox.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(_checkbox)
	_checkbox.connect("toggled", self, "_on_Checkbox_toggled")
	
	title = "Input"
	
	set_output_state(false)


func get_output_state() -> bool:
	return _output_state


func set_output_state(state: bool):
	_output_state = state
	_update_visuals()


func _update_visuals():
	_checkbox.pressed = _output_state
	
	var color := _off_color
	if _output_state:
		color = _on_color
	
	set_slot(0, false, 0, _off_color, true, 0, color)


func _on_Checkbox_toggled(button_pressed: bool):
	set_output_state(button_pressed)
