class_name PlugWaterHolesComponent extends ComponentSystem.BlockComponent

func on_tile_entered(tile: BAT.Tiles, cell: Vector2i) -> void:
	if not tile == BAT.Tiles.Water: return
	GridManager.set_tile_at(cell, BAT.Tiles.Ice)
	GridManager.remove_block_at(owner.grid_position)
