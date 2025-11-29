extends Node3D


var player_facing_direction: Vector2i = Vector2.RIGHT

var input_allowed: bool = true

@onready var UIManager = $UIManager
@onready var camera: Camera3D = $Camera3D

signal level_started()
signal level_completed()

var test_level: LevelData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	test_level = LevelData.new()
	test_level.level_id = "test00"
	test_level.level_number = 0
	test_level.initial_blocks = {Vector2i(0, 0): BAT.Blocks.Player}
	GameStateManager.level_completed.connect(on_level_completed)
	await get_tree().process_frame
	start_level("test00")
	

func _unhandled_key_input(event: InputEvent) -> void:
	if not input_allowed: return
	
	var direction = Vector2i.ZERO
	var action_type = ""
	
	if event.is_action_pressed("down"):
		direction = Vector2i(0, 1)
		action_type = "move"
	if event.is_action_pressed("up"):
		direction = Vector2i(0, -1)
		action_type = "move"
	if event.is_action_pressed("left"):
		direction = Vector2i(-1, 0)
		action_type = "move"
	if event.is_action_pressed("right"):
		direction = Vector2i(1, 0)
		action_type = "move"
	if event.is_action_pressed("push"):
		direction = player_facing_direction
		action_type = "push"
	if event.is_action_pressed("undo"):
		pass
	if event.is_action_pressed("restart"):
		pass
	
	if direction != Vector2i.ZERO:
		player_facing_direction = direction
		execute_move(action_type, direction)
		

func execute_move(action_type: String, direction: Vector2i):
	var move_data = {
		"type": "player_"+action_type,
		"direction": direction
	}
	
	#var success = GameStateManager.execute_move(move_data)
	GameStateManager.execute_move(move_data)

func restart_level():
	if GameStateManager.current_level:
		GameStateManager.load_level(GameStateManager.current_level)

func start_level(level_id: String):
	GameStateManager.load_level(test_level)
	level_started.emit()

func on_level_completed():
	input_allowed = false
	print("complete")
	level_completed.emit()

func enable_input():
	input_allowed = true


func disable_input():
	input_allowed = false
