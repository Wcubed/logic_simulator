extends Object
# Loads all the possible logic nodes at startup and keeps track of them.

# Dictionary of "TITLE" -> SCRIPT
var _logic_nodes := {}


# Loads all the logic nodes from the resources folder.
# This does not load recursively at the moment.
func load_logic_nodes(search_dir: String):
	var gd_files = []
	var dir = Directory.new()
	dir.open(search_dir)
	
	dir.list_dir_begin(true)
	
	while true:
		var file: String = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".gd"):
			gd_files.append(file)
	
	for gd_file in gd_files:
		var script := load(search_dir + "/" + gd_file)
		
		# Find out what to call this node.
		# TODO: do a check if the script fullfills
		#       the expected contract of a logic_node.
		# TODO: check for doubles.
		var node: LogicNode = script.new()
		var title := node.get_title()
		
		_logic_nodes[title] = script


func get_logic_nodes() -> Dictionary:
	return _logic_nodes
