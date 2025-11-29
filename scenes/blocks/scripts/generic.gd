class_name GenericBlock extends Resource

@export var block_type: BAT.Blocks = BAT.Blocks.Generic
var grid_position: Vector2i
var component_manager: ComponentSystem.ComponentManager
var visual_node: BlockRenderer
var is_moving: bool = false

signal animation_finished()
signal step_animation_finished()

func _init(cell: Vector2i = Vector2i.ZERO, type: BAT.Blocks = BAT.Blocks.Air):
	grid_position = cell
	block_type = type
	component_manager = ComponentSystem.ComponentManager.new()

func _ready() -> void:
	_setup_components()

func _setup_components() -> void:
	pass

func add_component(component: ComponentSystem.BlockComponent):
	component_manager.add_component(component)

func get_component(component_type: String) -> ComponentSystem.BlockComponent:
	return component_manager.get_component(component_type)

func has_component(component_type: String) -> bool:
	return component_manager.has_component(component_type)

func set_visual_node(node: BlockRenderer):
	visual_node = node
	if visual_node:
		visual_node.set_block_reference(self)

func get_visual_node() -> BlockRenderer:
	return visual_node


func start_slide_animation(path: Array[Vector2i]):
	if not visual_node:
		return
	
	is_moving = true
	Globals.set_input_disabled()
	var world_path: Array[Vector3] = []
	
	for cell in path:
		world_path.append(Vector3(cell.x, 0.1, cell.y))
	
	visual_node.animate_slide_path(world_path)
	await visual_node.slide_animation_finished
	
	is_moving = false
	Globals.set_input_enabled()
	animation_finished.emit()

func animate_single_step(to: Vector2i):
	if not visual_node: return
	
	Globals.set_input_disabled()
	var to_3 = Vector3(to.x, 0.1, to.y)
	visual_node.animate_single_step(to_3)
	await visual_node.step_animation_finished
	Globals.set_input_enabled()
	step_animation_finished.emit()

func attempt_push(direction: Vector2i) -> bool:
	var results = component_manager.call_on_all("on_push_attempt", [direction])
	return not false in results

func on_push_success(direction: Vector2i) -> void:
	component_manager.call_on_all("on_push_success", [direction])

func on_collision(other_block: GenericBlock) -> bool:
	var results = component_manager.call_on_all("on_collision", [other_block])
	return not false in results
