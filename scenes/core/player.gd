extends Node3D

@onready var player_model = $e/player
@onready var animation_player = $e/player/AnimationPlayer

@export var waddle_speed: float = 2.5

var collision_grid = CollisionGrid.new()

var facing_direction: Vector2i = Vector2i.RIGHT

class CollisionGrid:
	var grid = [] # Array[Array[bool]]
	
	func zero(size: Vector2i):
		grid.clear()
		for y in range(size.y):
			var row = []
			for x in range(size.x):
				row.append(false)
			grid.append(row)
			
	func rebuildGrid():
		grid.clear()
		for i in range(GridManager.grid_size.y):
			grid.append([])
		for cell in GridManager.tile_grid:
			if GridManager.is_valid_cell(cell) and GridManager.is_tile_walkable(cell) and not GridManager.is_position_blocked(cell):
				grid[cell.y].append(false)
			else:
				grid[cell.y].append(true)
	
	func is_colliding(pos: Vector2) -> bool:
		var cell = pos.floor()
		if grid.size() < 1: return true
		if not GridManager.is_valid_cell(pos.floor()): return true
		if grid.get(cell.y):
			if grid.get(cell.y).get(cell.x):
				return true
			else:
				return false
		else:
			return false


func _ready() -> void:
	GridManager.block_moved.connect(func(_a, _b, _c): collision_grid.rebuildGrid())
	GridManager.block_created.connect(func(_a, _b): collision_grid.rebuildGrid())
	GridManager.tile_changed.connect(func(_a, _b, _c): collision_grid.rebuildGrid())
	GridManager.update_visual_grid.connect(func(_a, _b): collision_grid.rebuildGrid())

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("push"):
		var target_cell = Vector2i(position.floor().x, position.floor().z)+facing_direction
		if GridManager.is_valid_cell(target_cell) and GridManager.get_block_object_at(target_cell):
			var block = GridManager.get_block_object_at(target_cell)
			block.attempt_push(facing_direction)

func _process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if abs(direction.x) > 0:
		facing_direction = Vector2i(direction.round().x, 0)
	elif abs(direction.y) > 0:
		facing_direction = Vector2i(0, direction.round().y)
	
	var movement = direction*delta*waddle_speed
	
	var new_pos = position + Vector3(movement.x, 0, movement.y)
	if not collision_grid.is_colliding(Vector2(new_pos.x, new_pos.z)):
		position = new_pos
