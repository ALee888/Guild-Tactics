extends Equipment

class_name Weapon

@export var damage: int
@export var range: int

func _ready() -> void:
	equipment_type = equipment_types.WEAPON
