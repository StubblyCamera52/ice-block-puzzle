extends BlockRenderer


@onready var animator = $model/player/AnimationPlayer
@onready var model = $model

func _ready() -> void:
	animator.play("Idle")

func animate_slide_path(world_path: Array[Vector3]):
	if world_path.is_empty():
		slide_animation_finished.emit()
		return
	
	var duration_per_step = 0.15
	
	var slide_tween = create_tween()
	model.look_at(world_path.back(), Vector3.UP, true)
	animator.play("Slide")
	for i in range(world_path.size()):
		var target_pos = world_path[i]
		
		slide_tween.tween_property(self, "position", target_pos, duration_per_step)
	
	slide_tween.tween_callback(func():
		animator.play("Idle")
		slide_animation_finished.emit())

func animate_single_step(to: Vector3):
	var step_tween = create_tween()
	animator.play("Waddle")
	model.look_at(to, Vector3.UP, true)
	step_tween.tween_property(self, "position", to, 0.25)
	step_tween.tween_callback(func():
		step_animation_finished.emit()
		animator.play("Idle"))
