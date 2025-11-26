extends Node3D

const block_models := {
	BAT.Blocks.Air: preload("res://scenes/blocks/generic.tscn"),
	BAT.Blocks.Ice: preload("res://scenes/blocks/ice.tscn"),
	BAT.Blocks.Player: preload("res://scenes/blocks/player.tscn")
}

const tile_models := {
	BAT.Tiles.Stone: preload("res://scenes/tiles/generic.tscn"),
	BAT.Tiles.Ice: preload("res://scenes/tiles/ice.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GridManager.update_visual_grid.connect(update_grids)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_grids(block_grid: Dictionary[Vector2i, BAT.Blocks], tile_grid: Dictionary[Vector2i, BAT.Tiles]):
	for n in get_children():
		remove_child(n)
		n.queue_free()
	for key: Vector2i in block_grid.keys():
		var block: PackedScene = block_models.get(block_grid.get(key))
		var block_instance: Node3D = block.instantiate()
		block_instance.position = Vector3(key.x, 1, key.y)
		add_child(block_instance)
	for key: Vector2i in tile_grid.keys():
		var tile: PackedScene = tile_models.get(tile_grid.get(key))
		var tile_instance: Node3D = tile.instantiate()
		tile_instance.position = Vector3(key.x, 1, key.y)
		add_child(tile_instance)
