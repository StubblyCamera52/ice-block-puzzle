extends Node

#BaT stands for Blocks and Tiles

enum Blocks {
	Air,
	Ice,
	Snow,
	Player,
	Heavy,
	Wall,
	Melting,
	IceMirror,
	FrozenBomb
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
}

const TileProperties := {
	Tiles.Generic: {
		"walkable": false,
		"slide_behavior": SlideBehavior.STOP,
		"slide_direction": Vector2i(0, 0), # 0, 0 means keep going in the direction its already going
	},
	Tiles.Stone: {
		"walkable": true,
		"slide_behavior": SlideBehavior.STOP,
		"slide_direction": Vector2i(0, 0)
	},
	Tiles.Ice: {
		"walkable": true,
		"slide_behavior": SlideBehavior.SLIDE,
		"slide_direction": Vector2i(0, 0)
	}
}

const BlockProperties := {
	Blocks.Air: {
		"collision": false,
		"pushable": false,
		"max_slide_distance": 0,
	},
	Blocks.Ice: {
		"collision": true,
		"pushable": true,
		"max_slide_distance": 3,
	},
	Blocks.Player: {
		"collision": true,
		"pushable": true,
		"max_slide_distance": 1
	}
}
