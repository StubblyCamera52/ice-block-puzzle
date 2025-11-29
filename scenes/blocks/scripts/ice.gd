class_name IceBlock extends GenericBlock

func _setup_components() -> void:
	var sliding = BlockSlidingComponent.new(self)
	add_component(sliding)
