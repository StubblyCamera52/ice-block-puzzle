class_name HeaterMeltsComponent extends ComponentSystem.BlockComponent

func on_tile_entered(tile: BAT.Tiles, cell: Vector2i) -> void:
	if not tile == BAT.Tiles.Heater: return
	if owner.block_type == BAT.Blocks.Snow:
		owner.animation_finished.connect(func(): GridManager.remove_block_at(cell))
		owner.step_animation_finished.connect(func(): GridManager.remove_block_at(cell))
	else:
		owner.animation_finished.connect(func(): 
			GridManager.remove_block_at(cell)
			GridManager.block_objects.set(cell, GridManager.create_block_at(cell, BAT.Blocks.Melting))
			GridManager.block_grid.set(cell, BAT.Blocks.Melting)
			Globals.set_input_enabled()
		)
		owner.step_animation_finished.connect(func():
			GridManager.remove_block_at(cell)
			GridManager.block_objects.set(cell, GridManager.create_block_at(cell, BAT.Blocks.Melting))
			GridManager.block_grid.set(cell, BAT.Blocks.Melting)
			Globals.set_input_enabled()
		)
