extends Node3D


var player_facing_direction: Vector2i = Vector2.RIGHT

@onready var UIManager = $UIManager
@onready var camera: Camera3D = $Camera3D
@onready var flag: Node3D = $flag

var current_level_id = 0

signal level_started()
signal level_completed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStateManager.level_completed.connect(on_level_completed)
	await get_tree().process_frame
	$MainMenuGUI/CenterContainer/MenuButtons/StartButton.pressed.connect(func():
		$MainMenuGUI.visible = false
		start_level(0)
	)
	#$MainMenuGUI/CenterContainer/MenuButtons/TutorialButton.pressed.connect(func(): $HelpUI.visible = true)
	#start_level("testlevel01")

func restart_level():
	if GameStateManager.current_level:
		GameStateManager.load_level(GameStateManager.current_level)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		start_level(current_level_id)

func start_level(level_id: int):
	Globals.unlock()
	Globals.set_input_enabled()
	var level: LevelData = Levels.parse_level_string(Levels.mainLevels[level_id])
	if not level: return
	current_level_id = level_id
	$Camera3D.position = Vector3((level.grid_size.x/2), 5.0, level.grid_size.y+1)
	$Player.position = Vector3(level.player_start_pos.x, 0, level.player_start_pos.y)
	var end_pos = level.goals[0].target_positions[0]
	if level.goals[0].goal_type != LevelData.LevelGoal.Type.REACH_EXIT:
		end_pos = Vector2(30, 30)
	flag.position = Vector3(end_pos.x+0.5, 0.1, end_pos.y+0.5)
	GameStateManager.load_level(level)
	$Player.collision_grid.rebuildGrid()
	level_started.emit()

func on_level_completed(level_data: LevelData):
	match level_data.level_id:
		"level00": start_level(1);return;
		"level01": start_level(2);return;
		"level02": start_level(3);return;
		"level03": start_level(4);return;
		"level04": start_level(5);return;
	Globals.set_input_disabled()
	Globals.lock()
	print("complete")
	level_completed.emit()


func _on_goalcheck_timeout() -> void:
	GameStateManager.check_goals()
