extends Skill

@onready var inventory: Node = $"../../Inventory"

func _ready() -> void:
	range = inventory.equipted_weapon.range
	damage = inventory.equipted_weapon.damage
