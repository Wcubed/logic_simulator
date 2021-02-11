extends PanelContainer

const LOGIC_NODE_DIR := "res://data/logic_nodes/"

var Graph := preload("res://data/logic_graph.gd")
var LogicNodeStore := preload("res://data/logic_node_store.gd")

var _graph: Object = null

onready var _graph_ui: HSplitContainer = $LogicGraphUi
onready var _logic_node_store := LogicNodeStore.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_logic_node_store.load_logic_nodes(LOGIC_NODE_DIR)
	
	_graph = Graph.new()
	
	# Example add.
	var nodes := _logic_node_store.get_logic_nodes()
	_graph.add_node(nodes["NOT"].new())
	_graph.add_node(nodes["AND"].new())
	_graph.add_node(nodes["OR"].new())
	
	_graph_ui.display_graph(_graph)
