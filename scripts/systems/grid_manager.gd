extends Node

var tile_grid: Dictionary[Vector2i, BAT.Tiles] = {}
var block_grid: Dictionary[Vector2i, BAT.Blocks] = {}
var tile_states: Dictionary[Vector2i, Dictionary] = {}
var block_states: Dictionary[Vector2i, Dictionary] = {}
var player_pos: Vector2i
var grid_size: Vector2i = Vector2i(10, 10)

signal block_moved(from: Vector2i, to: Vector2i, path: Array[Vector2i], type: BAT.Blocks)
signal tile_changed(cell: Vector2i, old: BAT.Tiles, new: BAT.Tiles)
signal block_created(cell: Vector2i, type: BAT.Blocks)
signal block_destroyed(cell: Vector2i, type: BAT.Blocks)
signal update_visual_grid(blocks: Dictionary[Vector2i, BAT.Blocks], tiles: Dictionary[Vector2i, BAT.Tiles])

func load_level_data(level_data: LevelData) -> void:
	grid_size = level_data.grid_size
	tile_grid = level_data.initial_tiles.duplicate()
	block_grid = level_data.initial_blocks.duplicate()
	player_pos = level_data.player_start_pos
	tile_states.clear()
	block_states.clear()
	
	# no unoccupied cells
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var cell = Vector2i(x, y)
			if not tile_grid.has(cell):
				tile_grid.set(cell, BAT.Tiles.Generic)
			if not block_grid.has(cell):
				block_grid.set(cell, BAT.Blocks.Air)
	
	block_grid.set(player_pos, BAT.Blocks.Player)
	
	update_visual_grid.emit(block_grid, tile_grid)

func execute_move(move_data: Dictionary) -> bool:
	var move_type = move_data.get("type", "")
	var move_direction = move_data.get("direction", Vector2i.ZERO)
	
	match move_type:
		"player_move":
			return attempt_player_move(move_direction)
		"player_push":
			return attempt_push(player_pos+move_direction, move_direction)
	
	return false

func attempt_player_move(move_direction: Vector2i) -> bool:
	var target_cell = player_pos + move_direction
	if not is_valid_cell(target_cell):
		return false
	
	var target_block = block_grid.get(target_cell, BAT.Blocks.Air)
	var target_tile = tile_grid.get(target_cell, BAT.Tiles.Generic)
	
	if target_block != BAT.Blocks.Air:
		if BAT.BlockProperties[target_block]["pushable"]:
			if not attempt_push(target_cell, move_direction):
				return false
		else:
			return false
	
	if not BAT.TileProperties[target_tile]["walkable"]:
		return false
	
	block_grid.set(player_pos, BAT.Blocks.Air)
	player_pos = target_cell
	block_grid.set(player_pos, BAT.Blocks.Player)
	
	var tile_properties = BAT.TileProperties[target_tile]
	if tile_properties["slide_behavior"] == BAT.SlideBehavior.SLIDE:
		var slide_path = compute_slide_path(player_pos, move_direction, BAT.Blocks.Player)
		if slide_path.size() > 0:
			block_grid[player_pos] = BAT.Blocks.Air
			player_pos = slide_path.back()
			block_grid[player_pos] = BAT.Blocks.Player
	
	update_visual_grid.emit(block_grid, tile_grid)
	return true

func compute_slide_path(start_cell: Vector2i, direction: Vector2i, block_type: BAT.Blocks) -> Array[Vector2i]:
	var max_slide_distance = BAT.BlockProperties[block_type]["max_slide_distance"]
	var slide_direction = direction
	var block_path: Array[Vector2i] = []
	var current_cell = start_cell
	
	for step in range(max_slide_distance):
		var next_cell = current_cell + slide_direction
		
		if not is_valid_cell(next_cell): break
		
		var next_cell_tile_type = tile_grid.get(next_cell, BAT.Tiles.Generic)
		var next_cell_block_type = block_grid.get(next_cell, BAT.Blocks.Air)
		
		if (BAT.BlockProperties[next_cell_block_type]["collision"]):
			handle_collision_effects(current_cell, next_cell, block_type, next_cell_block_type)
			break
		
		block_path.append(next_cell)
		current_cell = next_cell
		
		var next_cell_tile_properties =  BAT.TileProperties[next_cell_tile_type]
		match next_cell_tile_properties["slide_behavior"]:
			BAT.SlideBehavior.STOP:
				break
			BAT.SlideBehavior.SLIDE:
				continue
			BAT.SlideBehavior.DIRECTIONAL:
				slide_direction = next_cell_tile_properties["slide_direction"]
			BAT.SlideBehavior.CONDITIONAL:
				break
		
		handle_tile_effects(next_cell, block_type)
	
	return block_path

func handle_collision_effects(source_cell: Vector2i, target_cell: Vector2i, source_block: BAT.Blocks, target_block: BAT.Blocks):
	pass

func handle_tile_effects(cell: Vector2i, block_type: BAT.Blocks):
	pass


func attempt_push(cell: Vector2i, direction: Vector2i) -> bool:
	var block_type = block_grid.get(cell)
	var block_properties = BAT.BlockProperties.get(block_type)
	
	if !block_properties["pushable"]:
		return false
	
	var block_path = compute_slide_path(cell, direction, block_type)
	
	if block_path.size() == 0:
		return false
	
	#print(block_path)
	
	block_grid.set(cell, BAT.Blocks.Air)
	block_grid.set(block_path[block_path.size()-1], block_type)
	update_visual_grid.emit(block_grid, tile_grid)
	return true

func is_valid_cell(cell: Vector2i) -> bool:
	return (cell.x >= 0 and cell.x < grid_size.x) and (cell.y >= 0 and cell.y < grid_size.y)
