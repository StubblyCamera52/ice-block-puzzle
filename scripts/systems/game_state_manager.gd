extends Node

signal level_completed(level_data: LevelData)
signal level_failed()

var current_level: LevelData
var move_history: Array[GameStateSnapshot] = []
var max_undo_steps := 20

class GameStateSnapshot:
	var grid_state: Dictionary
	var block_positions: Dictionary
	var player_position: Dictionary
	var move_count: int
	var goals_state: Dictionary

func load_level(level_data: LevelData):
	current_level = level_data
	move_history.clear()


func save_state_snapshot():
	var snapshot = GameStateSnapshot.new()
	snapshot.player_position = GridManager.player_pos
	snapshot.move_count = move_history.size()
	
	move_history.push_back(snapshot)
	if move_history.size() > max_undo_steps:
		move_history.pop_front()

func check_goals():
	if current_level and current_level.check_completion():
		level_completed.emit(current_level)
