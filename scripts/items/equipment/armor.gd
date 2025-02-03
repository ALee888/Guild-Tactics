extends Equipment


@export var defense: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	equipment_type = equipment_types.ARMOR
