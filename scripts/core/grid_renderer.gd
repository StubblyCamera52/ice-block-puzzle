extends Node3D

#gotta rewrite this

# object pools
var tile_pool: Dictionary[BAT.Tiles, Array] = {}
var block_pool: Dictionary[BAT.Tiles, Array] = {}
var active_tiles: Dictionary[Vector2i, Node3D] = {}
var active_blocks: Dictionary[Vector2i, Node3D] = {}

signal animation_started()
signal animation_finished()

const block_models := {
	BAT.Blocks.Air: preload("res://scenes/blocks/generic.tscn"),
}

const tile_models := {
	BAT.Tiles.Generic: preload("res://scenes/tiles/generic.tscn"),
}
