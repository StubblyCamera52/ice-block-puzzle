class_name GenericBlock extends Node3D

@export var block_type: BAT.Blocks = BAT.Blocks.Generic
@export var grid_position: Vector2i = Vector2i()

var component_manager: ComponentSystem.ComponentManager
var is_moving: bool = false

var visual_state: Dictionary = {}

func _ready() -> void:
	component_manager = ComponentSystem.ComponentManager.new()
	_setup_components()

func _setup_components() -> void:
	pass

func add_component(component: ComponentSystem.BlockComponent):
	component_manager.add_component(component)

func get_component(component_type: String) -> ComponentSystem.BlockComponent:
	return component_manager.get_component(component_type)

func has_component(component_type: String) -> bool:
	return component_manager.has_component(component_type)

func attempt_push(direction: Vector2i) -> bool:
	var results = component_manager.call_on_all("on_push_attempt", [direction])
	return not false in results

func on_push_success(direction: Vector2i) -> void:
	component_manager.call_on_all("on_push_success", [direction])

func on_collision(other_block: GenericBlock) -> bool:
	var results = component_manager.call_on_all("on_collision", [other_block])
	return not false in results



func start_slide_animation(path: Array[Vector2i]):
	is_moving = true
	return
