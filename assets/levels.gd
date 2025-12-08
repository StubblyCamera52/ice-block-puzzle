extends Node

# """LEVEL_DEF
# [nameoflevel]|[width]|[height]
# initial tile grid def
# initial block grid def
# goal def (total num of goals)|[(type|posX|posY) per goal]

# tiles
# .  =stone, _ = hole, w = water, i = ice, h = heater, f = freezer, s = switch
# blocks
# I = ice, . = nothing (air?), # = invisblocking, S = snow, M = melting


func parse_level_string(level_string: String) -> LevelData:
	if not level_string: return null
	var data = LevelData.new()
	var lines = level_string.split("\n")
	
	if not lines.get(0) == "LEVEL_DEF": return null
	var level_metadata = lines.get(1).split("|")
	if not (level_metadata[0] or level_metadata[1] or level_metadata[2]): return null
	data.level_id = level_metadata[0]
	data.grid_size = Vector2i(level_metadata.get(1).to_int(), level_metadata.get(2).to_int())
	data.player_start_pos = Vector2(level_metadata.get(3).to_float()+0.5, level_metadata.get(4).to_float()+0.5)
	
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
				"h": data.initial_tiles.set(Vector2i(cellx, y), BAT.Tiles.Heater)
				"f": data.initial_tiles.set(Vector2i(cellx, y), BAT.Tiles.Freezer)
				"s": data.initial_tiles.set(Vector2i(cellx, y), BAT.Tiles.SwitchUnpressed)
				_: data.initial_tiles.set(Vector2i(cellx, y), BAT.Tiles.Stone)
	
	var block_offset = 3+data.grid_size.y
	if not lines.get(block_offset) == "BLOCK_DEF": return null
	for celly in range(block_offset+1, block_offset+1+data.grid_size.y):
		var block_row = lines.get(celly).split()
		var y = celly-(block_offset+1)
		for cellx in range(0, data.grid_size.x):
			match block_row.get(cellx):
				".": continue
				"I": data.initial_blocks.set(Vector2i(cellx, y), BAT.Blocks.Ice)
				"#": data.initial_blocks.set(Vector2i(cellx, y), BAT.Blocks.InvisibleBlocking)
				"M": data.initial_blocks.set(Vector2i(cellx, y), BAT.Blocks.Melting)
				"S": data.initial_blocks.set(Vector2i(cellx, y), BAT.Blocks.Snow)
				_: continue
	
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
testlevel00|4|4|0|0
TILE_DEF
..__
_.__
_.__
_..w
BLOCK_DEF
....
....
....
..I.
GOAL_DEF
1
2|3|3"""

const level00 = """LEVEL_DEF
level00|4|4|0|0
TILE_DEF
..__
_.__
_.__
_..w
BLOCK_DEF
....
....
....
..I.
GOAL_DEF
1
2|3|3"""

const level01 = """LEVEL_DEF
level01|5|5|0|2
TILE_DEF
.....
.....
.iii.
___w_
___._
BLOCK_DEF
.....
....I
.I...
###.#
.....
GOAL_DEF
1
2|3|4
"""

const level02 = """LEVEL_DEF
level02|8|5|0|4
TILE_DEF
...._...
...._...
iiiiwww.
...__...
...__...
BLOCK_DEF
....####
....####
.I......
.III####
...#####
GOAL_DEF
3
0|4|2
0|5|2
0|6|2
"""

const level03 = """LEVEL_DEF
level03|4|4|0|0
TILE_DEF
.iis
.iis
.iis
.iis
BLOCK_DEF
.I..
.I..
.I..
.I..
GOAL_DEF
4
1|3|0
1|3|1
1|3|2
1|3|3
"""

const level04 = """LEVEL_DEF
level04|4|4|0|0
TILE_DEF
.iis
.iis
.iis
.iis
BLOCK_DEF
.I..
.I..
.I..
.I..
GOAL_DEF
4
1|3|0
1|3|1
1|3|2
1|3|3
"""

const level05 = """LEVEL_DEF
level05|5|1|0|0
TILE_DEF
.ihfs
BLOCK_DEF
.I...
GOAL_DEF
1
1|4|0
"""

const testlevel01 = """LEVEL_DEF
level02|8|8|0|4
TILE_DEF
........
........
........
.....___
..iiwww.
.....___
...hf...
........
BLOCK_DEF
........
..SSMM..
........
.I..####
........
.II.####
........
........
GOAL_DEF
3
0|4|4
0|5|4
0|6|4
"""



const mainLevels = [
	level00, level01, level02, level03, level04, level05
]
