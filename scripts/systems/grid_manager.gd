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

func _ready() -> void:
	player_pos = Vector2i(0, 0)
	for i in range(14*14):
		if randf() > 0.5:
			tile_grid.set(Vector2i(i%14, floor(i/14)), BAT.Tiles.Stone)
		else:
			tile_grid.set(Vector2i(i%14, floor(i/14)), BAT.Tiles.Ice)
		block_grid.set(Vector2i(i%14, floor(i/14)), BAT.Blocks.Air)
	
	block_grid.set(Vector2i(0, 0), BAT.Blocks.Player)
	block_grid.set(Vector2i(1, 1), BAT.Blocks.Ice)
	
	print(tile_grid, block_grid)
	await get_tree().process_frame
	update_visual_grid.emit(block_grid, tile_grid)


func compute_slide_path(start_cell: Vector2i, direction: Vector2i, block_type: BAT.Blocks) -> Array[Vector2i]:
	var max_slide_distance = BAT.BlockProperties[block_type]["max_slide_distance"]
	var slide_direction = direction
	var block_path: Array[Vector2i] = []
	var previous_cell = start_cell
	
	for step in range(max_slide_distance):
		var next_cell = previous_cell + slide_direction
		if ((next_cell.x < 0 or next_cell.x > 13) or (next_cell.y < 0 or next_cell.y > 13)): break
		var next_cell_tile_type = tile_grid.get(next_cell)
		var next_cell_block_type = block_grid.get(next_cell)
		
		if (BAT.BlockProperties[next_cell_block_type]["collision"]): break
		
		var new_slide_direction: Vector2i = BAT.TileProperties[next_cell_tile_type]["slide_direction"]
		if new_slide_direction.length() > 0: slide_direction = new_slide_direction
		block_path.append(next_cell)
		if (BAT.TileProperties[next_cell_tile_type]["slide_behavior"] == BAT.SlideBehavior.STOP): break
		previous_cell = next_cell
		
	
	return block_path


func attempt_push(cell: Vector2i, direction: Vector2i) -> bool:
	var block_type = block_grid.get(cell)
	var block_properties = BAT.BlockProperties.get(block_type)
	
	if !block_properties["pushable"]:
		return false
	
	var block_path = compute_slide_path(cell, direction, block_type)
	if block_path.size() == 0:
		return false
	print(block_path)
	block_grid.set(cell, BAT.Blocks.Air)
	block_grid.set(block_path[block_path.size()-1], block_type)
	update_visual_grid.emit(block_grid, tile_grid)
	if block_type == BAT.Blocks.Player:
		update_player_pos.emit(block_path[block_path.size()-1])
	return true
