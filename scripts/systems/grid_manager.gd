extends Node

var tile_grid: Dictionary[Vector2i, BAT.Tiles] = {}
var block_grid: Dictionary[Vector2i, BAT.Blocks] = {}
var block_objects: Dictionary[Vector2i, GenericBlock] = {}

var grid_size: Vector2i = Vector2i(10, 10)


signal block_created(cell: Vector2i, block_obj: GenericBlock)
signal block_moved(from: Vector2i, to: Vector2i, type: BAT.Blocks)
signal tile_changed(cell: Vector2i, old: BAT.Tiles, new: BAT.Tiles)
signal update_visual_grid(block_grid: Dictionary, tile_grid: Dictionary)

# object tracking

func create_block_at(cell: Vector2i, block_type: BAT.Blocks) -> GenericBlock:
	var block_object: GenericBlock
	
	match block_type:
		BAT.Blocks.Ice: block_object = IceBlock.new(cell, block_type)
		BAT.Blocks.Player: block_object = PlayerBlock.new(cell, block_type)
	
	block_object._ready()
	block_created.emit(cell, block_object)
	return block_object



# utils
func is_valid_cell(cell: Vector2i) -> bool:
	return (cell.x >= 0 and cell.x < grid_size.x) and (cell.y >= 0 and cell.y < grid_size.y)

func get_tile_at(cell: Vector2i) -> BAT.Tiles:
	return tile_grid.get(cell, BAT.Tiles.Generic)

func get_block_at(cell: Vector2i) -> BAT.Blocks:
	return block_grid.get(cell, BAT.Blocks.Generic)

func get_block_object_at(cell: Vector2i) -> GenericBlock:
	return block_objects.get(cell)

func is_position_blocked(cell: Vector2i) -> bool:
	if not is_valid_cell(cell): return true
	
	var block_type = get_block_at(cell)
	return BAT.BlockProperties.get(block_type)["collision"]

func is_tile_walkable(cell: Vector2i) -> bool:
	var tile_type = get_tile_at(cell)
	return BAT.TileProperties.get(tile_type)["walkable"]

func load_level_data(level_data: LevelData) -> void:
	block_grid.clear()
	tile_grid.clear()
	grid_size = level_data.grid_size
	tile_grid = level_data.initial_tiles.duplicate()
	block_grid = level_data.initial_blocks.duplicate()
	
	for cell in block_grid:
		block_objects.set(cell, create_block_at(cell, block_grid[cell]))
	
	# no unoccupied cells
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var cell = Vector2i(x, y)
			if not tile_grid.has(cell):
				tile_grid.set(cell, BAT.Tiles.Generic)
			if not block_grid.has(cell):
				block_grid.set(cell, BAT.Blocks.Air)
	update_visual_grid.emit(block_grid, tile_grid)
	


#movement

func execute_block_movement(from: Vector2i, to: Vector2i) -> bool:
	var block_type = get_block_at(from)
	var block_object = get_block_object_at(from)
	
	if block_type == BAT.Blocks.Air: return false
	if not is_valid_cell(to) or is_position_blocked(to): return false
	
	block_grid.erase(from)
	block_grid.set(to, block_type)
	
	if block_object:
		block_objects.erase(from)
		block_objects.set(to, block_object)
		block_object.grid_position = to
		block_object.on_push_success(to-from)
	
	block_moved.emit(from, to, block_type)
	
	return true

func execute_movement_sequence(path: Array[Dictionary]) -> bool:
	#var backup_state = get_grid_state()
	
	for movement in path:
		var success = execute_block_movement(movement.from, movement.to)
		if not success:
			return false
	
	return true

func attempt_player_movement(direction: Vector2i) -> bool:
	var player_pos = get_player_pos()
	var target_pos = get_next_position_in_direction(player_pos, direction)
	
	if not is_valid_cell(target_pos): return false
	
	var target_block = get_block_object_at(target_pos)
	if target_block:
		var push_success = target_block.attempt_push(direction)
		if not push_success: return false
	
	if not is_tile_walkable(target_pos): return false
	
	var success = execute_block_movement(player_pos, target_pos)
	
	return success

func get_player_pos() -> Vector2i:
	for pos in block_grid.keys():
		if block_grid[pos] == BAT.Blocks.Player: return pos
	
	return Vector2i(-1, -1)

func execute_move(move_data: Dictionary) -> bool:
	match move_data.get("type", ""):
		"player_push":
			var target_cell = get_player_pos()+move_data.get("direction") as Vector2i
			if not is_valid_cell(target_cell): return false
			var target_block = get_block_object_at(target_cell) as GenericBlock
			var success = target_block.attempt_push(move_data.get("direction", Vector2i(0, 1)))
			return success
		_:
			return false


#pathing

func get_next_position_in_direction(cell: Vector2i, direction: Vector2i) -> Vector2i:
	return cell+direction

func find_first_collision_in_direction(cell: Vector2i, direction: Vector2i, max_dist: int = 99) -> Vector2i:
	var current_pos = cell
	
	for step in range(max_dist):
		var next_pos = get_next_position_in_direction(current_pos, direction)
		
		if not is_valid_cell(next_pos) or is_position_blocked(next_pos):
			return current_pos
		
		current_pos = next_pos
	
	return current_pos

func trace_path_until_stopped(start: Vector2i, direction: Vector2i, block_type: BAT.Blocks) -> Array[Vector2i]:
	var path: Array[Vector2i] = []
	var current_cell = start
	var current_direction = direction
	var max_distance = BAT.BlockProperties[block_type]["max_slide_distance"]
	
	for step in range(max_distance):
		var next_cell = get_next_position_in_direction(current_cell, current_direction)
		
		if not is_valid_cell(next_cell): break
		if is_position_blocked(next_cell): break
		
		path.append(next_cell)
		current_cell = next_cell
		
		var tile_type = get_tile_at(next_cell)
		var tile_properties = BAT.TileProperties[tile_type]
		
		match tile_properties["slide_behavior"]:
			BAT.SlideBehavior.STOP:
				break
			BAT.SlideBehavior.SLIDE:
				continue
			BAT.SlideBehavior.DIRECTIONAL:
				current_direction = tile_properties["slide_direction"]
			BAT.SlideBehavior.CONDITIONAL:
				continue
	
	return path

# state management (for undoing)
func get_grid_state() -> Dictionary:
	return {
		"tiles": tile_grid.duplicate(),
		"blocks": block_grid.duplicate(),
	}

func restore_state(state: Dictionary, player_pos: Vector2i):
	tile_grid = state["tiles"].duplicate()
	block_grid = state["blocks"].duplicate()
