class_name SnowBlock extends GenericBlock

func _setup_components() -> void:
	add_component(PushableComponent.new(self))
	add_component(HeaterMeltsComponent.new(self))
