class_name PushableComponent extends ComponentSystem.BlockComponent

func on_push_attempt(direction: Vector2i) -> bool:
	var original_cell = owner.grid_position
	var success = GridManager.execute_block_movement(original_cell, original_cell+direction)
	if owner.has_component("sliding"): return success
	if success:
		owner.animate_single_step(original_cell+direction)
	return success
