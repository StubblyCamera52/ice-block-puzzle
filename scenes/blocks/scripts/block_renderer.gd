class_name BlockRenderer extends Node3D

var block_reference: GenericBlock
var base_material: Material

signal slide_animation_finished()
signal step_animation_finished()
signal effect_finished(effect_name: String)

func _ready() -> void:
	pass

func set_block_reference(block: GenericBlock):
	block_reference = block

func animate_slide_path(world_path: Array[Vector3]):
	if world_path.is_empty():
		slide_animation_finished.emit()
		return
	
	var duration_per_step = 0.15
	
	var slide_tween = create_tween()
	for i in range(world_path.size()):
		var target_pos = world_path[i]
		
		slide_tween.tween_property(self, "position", target_pos, duration_per_step)
	
	slide_tween.tween_callback(func(): slide_animation_finished.emit())

func animate_single_step(to: Vector3):
	var step_tween = create_tween()
	step_tween.tween_property(self, "position", to, 0.1)
	step_tween.tween_callback(func(): step_animation_finished.emit())
