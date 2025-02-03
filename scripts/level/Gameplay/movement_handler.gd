extends Node2D

@onready var selection_handler: Node2D = %SelectionHandler

# Physics properties
const ANIMATION_SPEED = 40
const TILE_SIZE = 16
var path = []

signal movement_complete

var moving_unit: Unit

func _physics_process(delta: float) -> void:
	# While there are still members of the path
	#if path and state == Unit.unit_states.MOVING:
	if path:
		var next_position = Vector2(path.back()) * TILE_SIZE
		if moving_unit.global_position.distance_to(next_position) > 1:
			moving_unit.global_position = moving_unit.global_position.move_toward(next_position, ANIMATION_SPEED * delta)
		else:
			moving_unit.global_position = next_position  # Snap to tile once close enough
			moving_unit.current_tile = path.pop_back() # Remove completed coord from back of path and save current tile
			# If the path is complete
			if path.is_empty():
				# Unit is ready again
				moving_unit = null
				movement_complete.emit()


## Generate Path for unit to follow. Returns true if possible and false if not possible
func move(selected_unit, target_tile):
	# Allow movement if unit has not moved yet this turn
	if !selected_unit.moved:
		# Check if the tile is within movement range
		if Pathing.calc_h_cost(selected_unit.current_tile, target_tile) <= selected_unit.stats.agility:
			# Generate path to reach target_tile
			var new_path = Pathing.get_movement_path(selected_unit.current_tile, target_tile)
			# Path exists
			if new_path:
				print("final closed new_path: ", new_path)
				path = new_path
				moving_unit = selected_unit
				selected_unit.moved = true
				return true
			# Path does not exist
			else:
				print("Error: No valid path found")
				return false
		else:
			print("Unit is not fast enough to reach that tile")
			return false
	else:
		print("This unit has already moved!")
		return false
