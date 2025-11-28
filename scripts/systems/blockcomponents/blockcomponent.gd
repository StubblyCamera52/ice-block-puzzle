extends Node

class BlockComponent:
	var owner: GenericBlock
	var enabled := true
	
	func _init(block: GenericBlock) -> void:
		owner = block
	
	func on_added() -> void: pass
	func on_removed() -> void: pass
	func on_enabled() -> void: pass
	func on_disabled() -> void: pass
	
	func on_push_attempt(direction: Vector2i) -> bool: return true
	func on_push_success(direction: Vector2i) -> void: pass
	func on_slide_start(direction: Vector2i) -> void: pass
	func on_slide_step(current_cell: Vector2i, next_cell: Vector2i) -> bool: return true
	func on_slide_stop(final_cell: Vector2i) -> void: pass
	func on_collision(other_block: GenericBlock) -> bool: return true
	func on_tile_entered(tile: BAT.Tiles, cell: Vector2i) -> void: pass
	func on_tile_exited(tile: BAT.Tiles, cell: Vector2i) -> void: pass

class ComponentManager:
	var components: Array[BlockComponent] = []
	var components_by_types: Dictionary[String, BlockComponent] = {}
	
	func add_component(component: BlockComponent) -> void:
		components.append(component)
		components_by_types[component.get_script().get_global_name()] = component
		component.on_added()
	
	func remove_component(component_name: String) -> void:
		if components_by_types.has(component_name):
			var component = components_by_types[component_name]
			component.on_removed()
			components.erase(component)
			components_by_types.erase(component_name)
	
	func get_component(component_type: String) -> BlockComponent:
		return components_by_types.get(component_type)
	
	func has_component(component_type: String) -> bool:
		return components_by_types.has(component_type)
	
	func call_on_all(method: String, args: Array = []) -> Array:
		var results = []
		for component in components:
			if component.enabled and component.has_method(method):
				results.append(component.callv(method, args))
		return results
