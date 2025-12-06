extends Node

#BaT stands for Blocks and Tiles

enum Blocks {
	Generic,
	Air,
	Ice,
	Snow,
	Heavy,
	Wall,
	Melting,
	IceMirror,
	FrozenBomb,
	InvisibleBlocking
}

enum Tiles {
	Generic,
	Ice,
	Stone,
	Water,
	Hole,
	Heater,
	Freezer,
	Conveyor,
	ThinIce,
	Wind,
}

enum SlideBehavior {
	STOP,
	DIRECTIONAL,
	SLIDE,
	CONDITIONAL,
}

enum BlockState {
	NORMAL,
	MELTING,
	FROZEN,
	CRACKED
}



const TileProperties := {
	Tiles.Generic: {
		"walkable": true,
		"slide_behavior": SlideBehavior.STOP,
		"slide_direction": Vector2i(0, 0), # 0, 0 means keep going in the direction its already going
		"effects": []
	},
	Tiles.Stone: {
		"walkable": true,
		"slide_behavior": SlideBehavior.STOP,
		"slide_direction": Vector2i(0, 0),
		"effects": []
	},
	Tiles.Ice: {
		"walkable": true,
		"slide_behavior": SlideBehavior.SLIDE,
		"slide_direction": Vector2i(0, 0),
		"effects": []
	},
	Tiles.Water: {
		"walkable": false,
		"slide_behavior": SlideBehavior.STOP,
		"slide_direction": Vector2i(0, 0),
		"effects": ["drownable"]
	},
	Tiles.Hole: {
		"walkable": false,
		"slide_behavior": SlideBehavior.STOP,
		"slide_direction": Vector2i(0, 0),
		"effects": []
	},
	Tiles.Heater: {
		"walkable": true,
		"slide_behavior": SlideBehavior.STOP,
		"slide_direction": Vector2i(0, 0),
		"effects": ["melt_ice"]
	},
	Tiles.Freezer: {
		"walkable": true,
		"slide_behavior": SlideBehavior.STOP,
		"slide_direction": Vector2i(0, 0),
		"effects": ["freeze_melting"]
	},
	Tiles.Conveyor: {
		"walkable": true,
		"slide_behavior": SlideBehavior.DIRECTIONAL,
		"slide_direction": Vector2i(0, -1),
		"effects": ["force_move"]
	},
	Tiles.ThinIce: {
		"walkable": true,
		"slide_behavior": SlideBehavior.CONDITIONAL,
		"slide_direction": Vector2i(0, 0),
		"effects": ["breakable"],
		"break_threshold": 2
	},
	Tiles.Wind: {
		"walkable": true,
		"slide_behavior": SlideBehavior.DIRECTIONAL,
		"slide_direction": Vector2i(0, 1),
		"effects": ["wind_push"]
	}
}

const BlockProperties := {
	Blocks.Generic: {
		"collision": false,
		"pushable": false,
		"max_slide_distance": 0,
		"slide_on_ice": false,
		"abilities": [],
	},
	Blocks.Air: {
		"collision": false,
		"pushable": false,
		"max_slide_distance": 0,
		"slide_on_ice": false,
		"abilities": [],
	},
	Blocks.Ice: {
		"collision": true,
		"pushable": true,
		"max_slide_distance": 99,
		"slide_on_ice": true,
		"abilities": ["fill_holes"],
	},
	Blocks.Snow: {
		"collision": true,
		"pushable": true,
		"max_slide_distance": 99,
		"slide_on_ice": true,
		"abilities": ["soft_stop", "meltable"],
		"durability": 3
	},
	Blocks.Heavy: {
		"collision": true,
		"pushable": true,
		"max_slide_distance": 1,
		"slide_on_ice": false,
		"abilities": []
	},
	Blocks.Wall: {
		"collision": true,
		"pushable": false,
		"max_slide_distance": 0,
		"slide_on_ice": false,
		"abilities": [],
	},
	Blocks.Melting: {
		"collision": true,
		"pushable": true,
		"max_slide_distance": 99,
		"slide_on_ice": true,
		"abilities": ["one_time", "spawns_water"],
	},
	Blocks.IceMirror: {
		"collision": true,
		"pushable": true,
		"max_slide_distance": 99,
		"slide_on_ice": true,
		"abilities": ["reflect_beams"],
	},
	Blocks.FrozenBomb: {
		"collision": true,
		"pushable": true,
		"max_slide_distance": 99,
		"slide_on_ice": true,
		"abilities": ["explosive"],
		"explosion_radius": 1
	},
	Blocks.InvisibleBlocking: {
		"collision": true,
		"pushable": false,
		"max_slide_distance": 0,
		"slide_on_ice": false,
	}
}
