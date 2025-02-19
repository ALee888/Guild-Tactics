extends TileMapLayer


## Function to place indicator tiles in a given range
func build_range(range, current_tile) -> void:
	print("Current_tile", current_tile)
	## Builds a Tilemap UI outlining the range of a unit.
	var tile_index = {
		0: Vector2i(range * -1, 0)+current_tile, # left_tile
		2: Vector2i(0, range * -1)+current_tile, # bottom_tile
		4: Vector2i(range, 0)+current_tile, # right_tile
		6: Vector2i(0, range)+current_tile, # top_tile
	}
	for atlas_coord in range(8):
		# Even atlas_coord = Side tile
		if atlas_coord % 2 == 0:
			set_cell(tile_index[atlas_coord], 0, Vector2i(atlas_coord, 0))
		# Odd atlas_coord = Corner tile
		else:
			var start_tile = tile_index[atlas_coord-1]
			var end_tile = Vector2i()
			
			# Check atlas_coord = 7 to account for final corner (edge case)
			if atlas_coord == 7:
				end_tile = tile_index[0]
			else:
				end_tile = tile_index[atlas_coord+1]
			
			# Traverse and place corner tiles until end_tile is reached
			var build_vector = (end_tile - start_tile) / range # direction for corner placement
			var traversal_tile = start_tile + build_vector
			while traversal_tile != end_tile:
				set_cell(traversal_tile, 0, Vector2i(atlas_coord, 0))
				traversal_tile += build_vector
	visible = true # NOTE: might not need


## Function to place tiles indicating a unit's target range.
func build_combat_range(range: int, current_tile: Vector2i) -> void:
	# NOTE: Starting with horizontal and vertical range
	var directions = [
		Vector2i(1, 0), #right
		Vector2i(0, 1), # Down
		Vector2i(-1, 0), # Left
		Vector2i(0,-1) # Up
	]
	
	for direction in directions:
		var tile_ptr = Vector2i()
		# Place a tile in as many places as the weapon range
		for i in range(range):
			tile_ptr+=direction
			set_cell(current_tile+tile_ptr, 1, Vector2i(0, 0))

func show_targettable_units(current_tile: Vector2i, range: int) -> void:
	for enemy_unit in %Units.enemy_units:
		if Pathing.calc_h_cost(current_tile, enemy_unit.current_tile) <= range:
			set_cell(enemy_unit.current_tile, 1, Vector2i(0, 0))
			
