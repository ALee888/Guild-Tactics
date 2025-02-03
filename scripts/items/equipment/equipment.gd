extends Item

class_name Equipment

enum equipment_types {WEAPON, CONSUMABLE, ARMOR}

# Equipment Properties
var title: String
# TODO: @export var damage_type: String
@export var equipment_type: equipment_types
# var durabiltiy: int
# var weight: int
