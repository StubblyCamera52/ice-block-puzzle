extends Node

# """LEVEL_DEF
# [nameoflevel]|[width]|[height]
# initial tile grid def
# initial block grid def
# goal def (total num of goals)|[(type|posX|posY) per goal]

# tiles
# .  =stone, _ = hole, w = water, i = ice
# blocks
# P = player, I = ice, . = nothing (air?)


func parse_level_string(level_string: String) -> LevelData:
	if not level_string: return null
	var data = LevelData.new()
	var lines = level_string.split("\n")
	
	if not lines.get(0) == "LEVEL_DEF": return null
	var level_metadata = lines.get(1).split("|")
	if not (level_metadata[0] or level_metadata[1] or level_metadata[2]): return null
	data.level_id = level_metadata[0]
	data.grid_size = Vector2i(level_metadata.get(1).to_int(), level_metadata.get(2).to_int())
	
	if not lines.get(2) == "TILE_DEF": return null
	for celly in range(3, 3+data.grid_size.y):
		var tile_row = lines.get(celly).split()
		var y = celly-3
		for cellx in range(0, data.grid_size.x):
			match tile_row.get(cellx):
				".": data.initial_tiles.set(Vector2i(cellx, y), BAT.Tiles.Stone)
				"i": data.initial_tiles.set(Vector2i(cellx, y), BAT.Tiles.Ice)
				"w": data.initial_tiles.set(Vector2i(cellx, y), BAT.Tiles.Water)
				"_": data.initial_tiles.set(Vector2i(cellx, y), BAT.Tiles.Hole)
	
	var block_offset = 3+data.grid_size.y
	if not lines.get(block_offset) == "BLOCK_DEF": return null
	for celly in range(block_offset+1, block_offset+1+data.grid_size.y):
		var block_row = lines.get(celly).split()
		var y = celly-(block_offset+1)
		for cellx in range(0, data.grid_size.x):
			match block_row.get(cellx):
				".": continue
				"P": data.initial_blocks.set(Vector2i(cellx, y), BAT.Blocks.Player)
				"I": data.initial_blocks.set(Vector2i(cellx, y), BAT.Blocks.Ice)
	
	var goal_offset = block_offset+data.grid_size.y+1
	if not lines.get(goal_offset) == "GOAL_DEF": return null
	var num_goals = lines.get(goal_offset+1).to_int()
	if not num_goals > 0: return null
	
	for i in range(goal_offset+2, goal_offset+2+num_goals):
		var goal_data = lines.get(i).split("|")
		var goal = LevelData.LevelGoal.new()
		goal.goal_type = goal_data.get(0).to_int()
		goal.target_positions.append(Vector2i(goal_data.get(1).to_int(), goal_data.get(2).to_int()))
		data.goals.append(goal)
	
	return data

const testlevel00 = """LEVEL_DEF
testlevel00|10|10
TILE_DEF
..........
..........
..........
..........
..........
..........
..........
..........
..........
..........
BLOCK_DEF
P.........
.I........
..........
..........
..........
..........
..........
..........
..........
..........
GOAL_DEF
1
2|9|9"""
