extends Node


func get_movement_path(current_tile, target_tile):
	## Generate array of Vector2i tiles that lead to target_tile
	## NOTE: Algorithm source: https://www.geeksforgeeks.org/a-search-algorithm/ 
	var open_list = [Cell.new(current_tile, null, 0, 0)]
	var closed_list = []
	# While there are unchecked nodes
	while open_list:
		# Find node with min f on open list
		var q = get_min_f_tile(open_list)
		# Pop q off the open list
		open_list.erase(q)
		# Generate q's 4 successors and set their parents to q
		var successors = generate_tile_successors(q, target_tile)
			
		# d) For each successor
		for successor in successors:
			# If successor is goal, stop search
			if successor.position == target_tile:
				return make_path(successor)
			# else, compute both g and h for successor (Did already in generate_tile_successors)
			# Skip if successor does not follow
			if verify_successor(successor, open_list, closed_list):
				open_list.append(successor)
		closed_list.append(q)
	return null

func make_path(cell):
	## make the final path array with coordinates
	var path = [cell.position]
	var current_cell = cell.parent
	while current_cell.parent:
		# Traverse until no more parents
		path.append(current_cell.position)
		current_cell = current_cell.parent	
	return path
	
func get_min_f_tile(open_list):
	## Returns tile with the minimum f_cost in open_list
	var min_tile = open_list[0]
	for tile in open_list:
		if tile.f_cost < min_tile.f_cost:
			min_tile = tile
	return min_tile

func generate_tile_successors(q, target_tile):
	var directions = [
		Vector2i(1, 0), #right
		Vector2i(0, 1), # Down
		Vector2i(-1, 0), # Left
		Vector2i(0,-1) # Up
	]
	var successors = []
	for direction in directions:
		var position = q.position+direction
		var distance = 1 # Distance between successor and q (position and q.position)
		var g_cost = q.g_cost + distance
		var h_cost = abs(position.x - target_tile.x) + abs(position.y - target_tile.y) # Manhattan distance
		var successor = Cell.new(position, q, g_cost, h_cost)
		successors.append(successor)
	return successors

func verify_successor(successor, open_list, closed_list):
	# Node must have no duplicate positions in open_list with a lower f
	for tile in open_list:
		if tile.position == successor.position and tile.f_cost < successor.f_cost:
			return false
	for tile in closed_list:
		if tile.position == successor.position and tile.f_cost < successor.f_cost:
			return false
	return true
	
func calc_h_cost(current_tile, target_tile):
	# Heuristics:
	#TODO: Experiment with different approximations
	# Manhattan Distance
	print(current_tile.x)
	print(target_tile.x)
	var h_cost = abs(current_tile.x - target_tile.x) + abs(current_tile.y - target_tile.y)
	
	# Euclidean Distance
	return h_cost
