class_name IceBlock extends GenericBlock

func _setup_components() -> void:
	add_component(PushableComponent.new(self))
	add_component(BlockSlidingComponent.new(self))
