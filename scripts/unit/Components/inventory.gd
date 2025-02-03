extends Node

@export var equipted_weapon: Weapon
@export var equipted_armor: Weapon
var items = []

func _ready() -> void:
	# Assign unarmed if no weapon equipted
	if !equipted_weapon:
		equipted_weapon = get_node("Unarmed")


func list_items():
	for item in items:
		print(item.name)
