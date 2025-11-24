extends Node

var tile_grid: Dictionary[Vector2i, BAT.Tiles]
var block_grid: Dictionary[Vector2i, BAT.Blocks]

func _ready() -> void:
	for i in range(14*14):
		tile_grid.set(Vector2i(i%14, floor(i/14)), BAT.Tiles.Stone)
		block_grid.set(Vector2i(i%14, floor(i/14)), BAT.Blocks.Air)
	
	print(tile_grid, block_grid)
