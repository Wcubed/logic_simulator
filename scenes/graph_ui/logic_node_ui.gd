extends GraphNode

const DISABLED_COLOR := Color(0.5, 0.5, 0.5)
const ENABLED_COLOR := Color(1.0, 0.1, 0.1)


var LogicNodeLabel := preload("logic_node_label.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_title(new_title: String):
	title = new_title


func update_input_output_amounts(node: LogicNode):
	for child in get_children():
		child.free()
	
	var input_amount := node.get_inputs_amount()
	var output_amount := node.get_outputs_amount()
	var max_amount: int = max(input_amount, output_amount)
	
	var input_labels := node.get_input_labels()
	var output_labels := node.get_output_labels()
	
	for i in max_amount:
		var labels: Control = LogicNodeLabel.instance()
		add_child(labels)
		
		var has_input: bool = i < input_amount
		var has_output: bool = i < output_amount
		
		if has_input:
			labels.set_input_label(input_labels[i])
		if has_output:
			labels.set_output_label(output_labels[i])
		
		set_slot(i, has_input, 0, DISABLED_COLOR, has_output, 0, DISABLED_COLOR)


func update_input_output_state(input_state: Array, output_state: Array):
	var max_size: int = max(input_state.size(), output_state.size())
	
	for i in max_size:
		var input_enabled: bool = i < input_state.size()
		var output_enabled: bool = i < output_state.size()
		
		var input_color := DISABLED_COLOR
		if input_enabled:
			if input_state[i]:
				input_color = ENABLED_COLOR
		
		var output_color := DISABLED_COLOR
		if output_enabled:
			if output_state[i]:
				output_color = ENABLED_COLOR
		
		# TODO: Make this function update both input and output states?
		set_slot(i, input_enabled, 0, input_color, output_enabled, 0, output_color)
