class_name GenericBlock extends Node3D

@export var block_type: BAT.Blocks = BAT.Blocks.Generic
var visual_state: Dictionary = {}

func set_visual_state(state: String, value):
	visual_state[state] = value
	update_visual_apperance()

func update_visual_apperance():
	pass

# animation and effect hooks

func on_move_started():
	pass

func on_move_finished():
	pass

func on_collision():
	pass
