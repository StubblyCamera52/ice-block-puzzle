extends Node3D


var player_facing_direction: Vector2i = Vector2.RIGHT

@onready var UIManager = $UIManager
@onready var camera: Camera3D = $Camera3D
@onready var flag: Node3D = $flag

signal level_started()
signal level_completed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStateManager.level_completed.connect(on_level_completed)
	await get_tree().process_frame
	start_level("level00")

func restart_level():
	if GameStateManager.current_level:
		GameStateManager.load_level(GameStateManager.current_level)

func start_level(level_id: String):
	Globals.unlock()
	Globals.set_input_enabled()
	var level: LevelData
	match level_id:
		"level00": level = Levels.parse_level_string(Levels.level00)
		"level01": level = Levels.parse_level_string(Levels.level01)
		"level02": level = Levels.parse_level_string(Levels.level02)
	if not level: return
	$Camera3D.position = Vector3((level.grid_size.x/2), 5.0, level.grid_size.y+.5)
	var end_pos = level.goals[0].target_positions[0]
	flag.position = Vector3(end_pos.x, 0.1, end_pos.y)
	GameStateManager.load_level(level)
	$Player.collision_grid.rebuildGrid()
	level_started.emit()

func on_level_completed(level_data: LevelData):
	match level_data.level_id:
		"level00":start_level("level01");return;
		"level01":start_level("level02");return;
	Globals.set_input_disabled()
	Globals.lock()
	print("complete")
	level_completed.emit()
