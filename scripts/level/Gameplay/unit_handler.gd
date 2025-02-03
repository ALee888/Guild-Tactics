extends Node2D
@onready var enemy_units_node: Node2D = $EnemyUnits
@onready var player_units_node: Node2D = $PlayerUnits

var player_units = [] # TODO: could remove this in favor of get_children every time
var enemy_units = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_units = player_units_node.get_children()
	enemy_units = enemy_units_node.get_children()


## Reset array of current units in player and enemy handlers and the big array here.
func set_units():
	# TODO: Optimize
	# Player units
	var remaining_units = []
	# Loop through all children and
	for child in player_units_node.get_children():
		# if a child is not ready for deletion, append
		if !child.is_queued_for_deletion():
			remaining_units.append(child)
	player_units = remaining_units
	# Enemy units TODO
	enemy_units_node.set_units()
	

## Check given tile to see if a unit is present.
## Return: unit
func get_tile(target_tile: Vector2i):
	for unit in player_units:
		if unit.current_tile == target_tile:
			return unit
	for unit in enemy_units:
		if unit.current_tile == target_tile:
			return unit
	return null


## Loops through chosen unit type and resets properties to start the turn
func reset_units(unit_type: Unit.unit_types) -> void:
	if unit_type == Unit.unit_types.PLAYER:
		for unit in player_units:
			unit.moved = false
			unit.took_action = false
	elif unit_type == Unit.unit_types.ENEMY:
		for unit in enemy_units:
			unit.moved = false
			unit.took_action = false


## loops through player units and returns true if player has no more moves left
func check_player_finished() -> bool:
	for unit in player_units:
		# If a unit remains not moved, turn is not finished
		if !unit.moved or !unit.took_action:
			return false
		# Otherwise turn is not over
		else:
			return true
	print("No more units in check_player_finished")
	return true
