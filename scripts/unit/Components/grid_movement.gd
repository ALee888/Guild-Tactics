extends Node

#@onready var tile_map: TileMapLayer = %TileMap
@onready var unit: CharacterBody2D = $".."
@onready var pathing: Node = $Pathing

signal movement_complete


# Physics properties
const ANIMATION_SPEED = 40
const TILE_SIZE = 16
var path = []

func _physics_process(delta: float) -> void:
	# While there are still members of the path
	if path and unit.state == unit.unit_states.MOVING:
		var next_position = Vector2(path.back()) * TILE_SIZE
		if unit.global_position.distance_to(next_position) > 1:
			unit.global_position = unit.global_position.move_toward(next_position, ANIMATION_SPEED * delta)
		else:
			unit.global_position = next_position  # Snap to tile once close enough
			unit.current_tile = path.pop_back() # Remove completed coord from back of path and save current tile
			# If the path is complete
			if path.is_empty(): 
				# Unit is ready again
				unit.state = unit.unit_states.READY
				movement_complete.emit()


func move_to(target_tile):
	## Returns true if path if unit can move or false if unit cannot move.
	# TODO: Pathing might move back to unit handler
	# Check if the tile is within movement range
	if pathing.calc_h_cost(unit.current_tile, target_tile) <= unit.stats.agility:
		# Generate path to reach target_tile
		var new_path = pathing.get_movement_path(unit.current_tile, target_tile)
		# Path exists
		if new_path:
			print("final closed new_path: ", new_path)
			path = new_path
			return true
		# Path does not exist
		else:
			print("Error: No valid path found")
			return false
	else:
		print("Unit is not fast enough to reach that tile")
		return false
