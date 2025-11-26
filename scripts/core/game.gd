extends Node3D


var player_pos: Vector2i = Vector2i(0, 0)
var player_facing_direction: Vector2i = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GridManager.update_player_pos.connect(update_player_pos)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		player_facing_direction = Vector2i(0, 1)
		GridManager.attempt_push(player_pos, Vector2i(0, 1))
	if event.is_action_pressed("up"):
		player_facing_direction = Vector2i(0, -1)
		GridManager.attempt_push(player_pos, Vector2i(0, -1))
	if event.is_action_pressed("left"):
		player_facing_direction = Vector2i(-1, 0)
		GridManager.attempt_push(player_pos, Vector2i(-1, 0))
	if event.is_action_pressed("right"):
		player_facing_direction = Vector2i(1, 0)
		GridManager.attempt_push(player_pos, Vector2i(1, 0))
	if event.is_action_pressed("push"):
		GridManager.attempt_push(player_pos+player_facing_direction, player_facing_direction)
		

func update_player_pos(new_player_pos: Vector2i):
	player_pos = new_player_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
