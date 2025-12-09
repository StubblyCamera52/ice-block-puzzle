extends Control

const goal_texts = [
	"Get to the [b]Flag[/b]",
	"Get to the [b]Flag[/b]",
	"Fill all of the [b]Water Holes[/b]",
	"Activate all of the [b]Switches[/b]",
	"Activate the [b]Switch[/b]",
	"Activate the [b]Switches[/b], and reach the [b]exit[/b]"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("/root/Game").level_started.connect(update_goals)


func update_goals() -> void:
	match GameStateManager.current_level.level_id:
		"level00": $RichTextLabel.clear(); $RichTextLabel.append_text(goal_texts[0])
		"level01": $RichTextLabel.clear(); $RichTextLabel.append_text(goal_texts[1])
		"level02": $RichTextLabel.clear(); $RichTextLabel.append_text(goal_texts[2])
		"level03": $RichTextLabel.clear(); $RichTextLabel.append_text(goal_texts[3])
		"level04": $RichTextLabel.clear(); $RichTextLabel.append_text(goal_texts[4])
		"level05": $RichTextLabel.clear(); $RichTextLabel.append_text(goal_texts[5])
