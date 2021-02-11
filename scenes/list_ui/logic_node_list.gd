extends ScrollContainer

# Emitted when the user wants to add one of the available nodes.
signal add_node_pressed(title)


var NodeListEntry := preload("node_list_entry.tscn")
var _logic_node_store: Object = null


onready var container := $VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# When the logic store is changed,
# the selectable nodes change accordingly.
func set_logic_node_store(new_store: Object):
	_logic_node_store = new_store
	
	for child in container.get_children():
		child.free()
		
	# Call after all out children have been cleared.
	call_deferred("_fill_list")


# Fills the list with the possible logic nodes.
func _fill_list():
	if _logic_node_store == null:
		return
	
	for title in _logic_node_store.get_logic_nodes().keys():
		var entry: Control = NodeListEntry.instance()
		
		container.add_child(entry)
		
		entry.set_title(title)
		entry.connect("add_node_pressed", self, "_on_entry_add_node_pressed")


func _on_entry_add_node_pressed(title: String):
	emit_signal("add_node_pressed", title)
