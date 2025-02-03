extends Node


var skill_list: Array[Skill]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get all skill nodes and store in the skill list
	for child in get_children():
		if child is Skill:
			skill_list.append(child)
