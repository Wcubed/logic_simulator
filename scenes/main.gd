extends PanelContainer

var Graph := preload("res://data/logic_graph.gd")

var _graph: Object = null

onready var _graph_ui: HSplitContainer = $LogicGraphUi

# Called when the node enters the scene tree for the first time.
func _ready():
	_graph = Graph.new()
	
	# Example add.
	_graph.add_node(load("res://data/logic_nodes/logic_and.gd").new())
	
	_graph_ui.display_graph(_graph)
