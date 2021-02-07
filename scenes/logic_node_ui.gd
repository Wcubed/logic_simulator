extends GraphNode

const DISABLED_COLOR := Color(0.5, 0.5, 0.5)
const ENABLED_COLOR := Color(1.0, 0.1, 0.1)


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
	
	for i in max_amount:
		add_child(Label.new())
		
		var has_input: bool = i < input_amount
		var has_output: bool = i < output_amount
		
		set_slot(i, has_input, 0, DISABLED_COLOR, has_output, 0, DISABLED_COLOR)


func update_output_state(state: Array):
	for i in state.size():
		var color := DISABLED_COLOR
		if state[i]:
			color = ENABLED_COLOR
		
		# TODO: Make this function update both input and output states?
		set_slot(i, is_slot_enabled_left(i), 0, get_slot_color_left(i), true, 0, color)
