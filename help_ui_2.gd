extends Control

const help_texts = [
	"Move with [b]Arrow Keys[/b], Push blocks with [b]Space[/b], [b]H[/b] to restart level",
	"[b]Ice Blocks[/b] slide on [b]Ice[/b]",
	"Fill all of the [b]Water Holes[/b]",
	"Activate all of the [b]Switches[/b]",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("/root/Game").level_started.connect(update_helps)


func update_helps() -> void:
	match GameStateManager.current_level.level_id:
		"level00": $RichTextLabel.clear(); $RichTextLabel.append_text(help_texts[0])
		"level01": $RichTextLabel.clear(); $RichTextLabel.append_text(help_texts[1])
		"level02": $RichTextLabel.clear(); $RichTextLabel.append_text(help_texts[2])
		"level03": $RichTextLabel.clear(); $RichTextLabel.append_text(help_texts[3])
		_: $RichTextLabel.clear();
