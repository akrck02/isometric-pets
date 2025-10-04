class_name Nodes

## Stop all the processing of a node
static func stop_node_logic_process(node : Node):
	node.set_physics_process(false)
	node.set_process(false)
	node.set_process_input(false)
	node.set_process_unhandled_input(false)
