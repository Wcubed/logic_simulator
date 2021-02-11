extends PanelContainer

const LOGIC_NODE_DIR := "res://data/logic_nodes/"

var Graph := preload("res://data/logic_graph.gd")
var LogicNodeStore := preload("res://data/logic_node_store.gd")

var _graph: Object = null
var _logic_node_store := LogicNodeStore.new()

onready var _node_list_ui: ScrollContainer = $HSplitContainer/LogicNodeList
onready var _graph_ui: HSplitContainer = $HSplitContainer/LogicGraphUi

# Called when the node enters the scene tree for the first time.
func _ready():
	_logic_node_store.load_logic_nodes(LOGIC_NODE_DIR)
	_node_list_ui.set_logic_node_store(_logic_node_store)
	
	_graph = Graph.new()
	_graph_ui.display_graph(_graph)


func _on_LogicNodeList_add_node_pressed(title: String):
	var new_node: LogicNode = _logic_node_store.get_logic_nodes()[title].new()
	_graph.add_node(new_node)
