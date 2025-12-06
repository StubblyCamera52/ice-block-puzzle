class_name FreezerFreezesComponent extends ComponentSystem.BlockComponent

func on_tile_entered(tile: BAT.Tiles, cell: Vector2i) -> void:
	if not tile == BAT.Tiles.Freezer: return
	owner.animation_finished.connect(func():
		GridManager.remove_block_at(cell)
		GridManager.block_objects.set(cell, GridManager.create_block_at(cell, BAT.Blocks.Ice))
		GridManager.block_grid.set(cell, BAT.Blocks.Ice)
		Globals.set_input_enabled()
	)
	owner.step_animation_finished.connect(func():
		GridManager.remove_block_at(cell)
		GridManager.block_objects.set(cell, GridManager.create_block_at(cell, BAT.Blocks.Ice))
		GridManager.block_grid.set(cell, BAT.Blocks.Ice)
		Globals.set_input_enabled()
	)
