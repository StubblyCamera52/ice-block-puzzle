class_name GridRenderer extends Node3D

var active_tiles: Dictionary[Vector2i, GenericTile] = {}

@export var block_height_offset: float = 0.1

const tile_models := {
	BAT.Tiles.Generic: preload("res://scenes/tiles/generic.tscn"),
	BAT.Tiles.Stone: preload("res://scenes/tiles/stone.tscn"),
	BAT.Tiles.Ice: preload("res://scenes/tiles/ice.tscn"),
	BAT.Tiles.Water: preload("res://scenes/tiles/water.tscn"),
	BAT.Tiles.Hole: preload("res://scenes/tiles/hole.tscn")
}

const block_models := {
	BAT.Blocks.Ice: preload("res://scenes/blocks/ice.tscn"),
	BAT.Blocks.Player: preload("res://scenes/blocks/player.tscn"),
}

func _ready() -> void:
	GridManager.update_visual_grid.connect(_on_full_grid_update)
	GridManager.tile_changed.connect(_on_tile_changed)
	GridManager.block_created.connect(_on_block_created)

# grid updates
func _on_full_grid_update(block_grid: Dictionary, tile_grid: Dictionary):
	_clear_all_visuals()
	for cell in tile_grid.keys():
		_create_tile_at(cell, tile_grid[cell])

func _clear_all_visuals():
	for tile_obj in active_tiles.values():
		if is_instance_valid(tile_obj):
			tile_obj.queue_free()
	active_tiles.clear()

#obj manage
func _create_tile_at(cell: Vector2i, type: BAT.Tiles):
	var model: PackedScene = tile_models.get(type)
	if not model: return
	
	var tile_obj = model.instantiate() as GenericTile
	if not tile_obj: return
	
	tile_obj.position = Vector3(cell.x, 0, cell.y)
	add_child(tile_obj)
	
	active_tiles.set(cell, tile_obj)

func _on_tile_changed(cell: Vector2i, old: BAT.Tiles, new: BAT.Tiles):
	if active_tiles.has(cell):
		var old_tile = active_tiles.get(cell)
		if is_instance_valid(old_tile):
			old_tile.queue_free()
		active_tiles.erase(cell)
	
	_create_tile_at(cell, new)

func _on_block_created(cell: Vector2i, block_obj: GenericBlock):
	var block_model: PackedScene = block_models.get(block_obj.block_type)
	if not block_model: return
	var block_renderer = block_model.instantiate() as BlockRenderer
	if not block_renderer: return
	block_renderer.position = Vector3(cell.x, 0, cell.y)
	add_child(block_renderer)
	block_obj.set_visual_node(block_renderer)
