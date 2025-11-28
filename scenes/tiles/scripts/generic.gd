class_name GenericTile extends Node3D

@export var TileType: BAT.Tiles = BAT.Tiles.Generic


# visual hooks
func on_block_entered(block: BAT.Blocks):
	pass

func on_block_exited(block: BAT.Blocks):
	pass
