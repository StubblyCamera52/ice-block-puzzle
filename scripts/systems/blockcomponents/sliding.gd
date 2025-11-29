class_name BlockSlidingComponent extends ComponentSystem.BlockComponent

@export var max_slide_distance: int = 99
@export var slides_on_ice: bool = true
@export var slides_on_stone: bool = false


func on_push_success(direction: Vector2i) -> void:
	if should_slide_after_push():
		_execute_slide(direction)

func should_slide_after_push() -> bool:
	var current_tile = GridManager.get_tile_at(owner.grid_position)
	return _should_slide_on_tile(current_tile)

func _should_slide_on_tile(tile_type: BAT.Tiles) -> bool:
	match tile_type:
		BAT.Tiles.Ice: return slides_on_ice
		BAT.Tiles.Stone: return slides_on_stone
		_: return false

func _execute_slide(direction: Vector2i):
	_slide_standard(direction)

func _slide_standard(direction):
	var start_pos = owner.grid_position
	var slide_path = GridManager.trace_path_until_stopped(start_pos, direction, owner.block_type)
	
	if slide_path.size() == 0:
		return
	
	var final_pos = slide_path.back()
	var movement_success = GridManager.execute_block_movement(start_pos, final_pos)
	
	if movement_success:
		owner.start_slide_animation(slide_path)

func _handle_slide_complete(final_cell: Vector2i):
	for component in owner.component_manager.components:
		if component != self and component.has_method("on_slide_stop"):
			component.callv("on_slide_stop", [final_cell])
