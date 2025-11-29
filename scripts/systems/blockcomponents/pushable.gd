class_name PushableComponent extends ComponentSystem.BlockComponent

func on_push_attempt(direction: Vector2i) -> bool:
	return GridManager.execute_block_movement(owner.grid_position, owner.grid_position+direction)
