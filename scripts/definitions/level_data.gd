class_name LevelData extends Resource

@export var level_id: String
@export var level_number: int
@export var grid_size: Vector2i = Vector2i(10, 10)
@export var initial_tiles: Dictionary[Vector2i, BAT.Tiles]
@export var initial_blocks: Dictionary[Vector2i, BAT.Blocks]
@export var player_start_pos: Vector2 = Vector2(0, 5)
@export var goals: Array[LevelGoal] = []

class LevelGoal extends Resource:
	enum Type {
		FILL_HOLES,
		ACTIVATE_SWITCHES,
		REACH_EXIT,
		REFLECT_BEAMS,
		BUILD_BRIDGES
	}
	
	@export var goal_type: Type
	@export var target_positions: Array[Vector2i] = []
	@export var target_count: int = 1
	
	func check_completion() -> bool:
		match goal_type:
			Type.FILL_HOLES:
				if GridManager.get_tile_at(target_positions[0]) != BAT.Tiles.Water:
					return true
				return false
			Type.ACTIVATE_SWITCHES:
				if GridManager.get_block_at(target_positions[0]) == BAT.Blocks.Ice:
					return true
				else:
					return false
			Type.REACH_EXIT:
				if GridManager.get_player_pos().length() == target_positions[0].length():
					return true
				return false
			Type.REFLECT_BEAMS:
				return false
			Type.BUILD_BRIDGES:
				return false
		return false

func check_completion() -> bool:
	for goal in goals:
		if not goal.check_completion():
			return false	
	return true
