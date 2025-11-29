class_name PlayerBlock extends GenericBlock

func _setup_components() -> void:
	add_component(PushableComponent.new(self))
