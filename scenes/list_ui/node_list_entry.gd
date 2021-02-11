extends HBoxContainer

signal add_node_pressed(title)


# Title of the node we represent.
var _title := ""

onready var _add_button := $AddButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_title(title: String):
	_title = title
	_add_button.text = title


func _on_AddButton_pressed():
	emit_signal("add_node_pressed", _title)
