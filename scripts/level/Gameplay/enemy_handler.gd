extends Node2D

@onready var enemy_units: Node2D = $"../Units/EnemyUnits"
@onready var units: Node2D = $"../Units"

signal enemy_turn_over

var enemy_initiative = []
var selected_enemy = Unit
var queue = []
const TILE_SIZE = 16
const ANIMATION_SPEED = 40

func _physics_process(delta: float) -> void:
	# While there are instructions in the queue
	if queue:
		
		var next_instruction = queue.back()
		# If the instruction is coordinates, Move to the location
		if next_instruction is Vector2i:
			var next_position = Vector2(next_instruction) * TILE_SIZE
			if global_position.distance_to(next_position) > 1:
				global_position = global_position.move_toward(next_position, ANIMATION_SPEED * delta)
			else:
				global_position = next_position
				selected_enemy.current_tile = queue.pop_back()
				# If the path is complete
				if queue.is_empty(): 
					# Unit is ready again
					make_move()
		elif next_instruction is Unit:
			var target = queue.pop_back()
			Combat.weapon_attack(selected_enemy, target)
			if enemy_initiative == []:
				enemy_turn_over.emit()
			else:
				make_move()

## Start of turn, reset all enemy units
func start_turn():
	# Set initiative
	enemy_initiative = units.enemy_units
	enemy_initiative.sort_custom(sort_speed)
	# Execute first move
	make_move()


## Custom sort so enemy units take turns in order of speed
func sort_speed(unit1, unit2):
	if unit1.stats.agility < unit2.stats.agility:
		return true
	return false


## Generate a move for the next enemy unit in initiative and add it to the queue
func make_move() -> void:
	# Take next enemy in initiative
	var unit = enemy_initiative.pop_front()
	# Generate and execute instructions
	queue = get_instruction_queue(unit)


## Return a list of instructions for the enemy to follow
func get_instruction_queue(enemy: Unit): 
	#print(enemy.name, " is deciding best action")
	# TODO: Different classes will have different behavior
	# Mindless units charge forward to the nearest enemy and attacks
	if enemy.tactics == "Mindless":
		# Get nearest enemy
		var target = get_nearest_opponent(enemy.current_tile)
		# If the target is within range, attack
		if target.current_tile in Combat.get_targetable_tiles(enemy.current_tile, enemy.inventory.equipted_weapon.range):
			Combat.weapon_attack(enemy, target)
		# Otherwise, move toward him
		else:
			var movement_path = Pathing.get_movement_path(enemy.current_tile, target.current_tile)
			# Follow path and stop when unit is within range of target
			var queue = []
			while movement_path:
				var next_tile = movement_path.pop_back()
				# Check if the target is now in range
				if target.current_tile in Combat.get_targetable_tiles(next_tile, enemy.inventory.equipted_weapon.range):
					queue.push_front(next_tile)
					queue.push_front(target)
					return queue
				else:
					queue.push_front(next_tile)
			return queue


## Given a target tile, return the nearest opponent
func get_nearest_opponent(unit_tile: Vector2i) -> Unit:
	var closest_unit: Unit
	var min_distance: int
	# Loop through 
	for player_unit in units.player_units:
		var distance = Pathing.calc_h_cost(unit_tile, player_unit.current_tile)
		# Keep the closest unit
		if closest_unit and min_distance:
			if distance < min_distance:
				closest_unit = player_unit
				min_distance = distance
		# First loop, set variables
		else:
			closest_unit = player_unit
			min_distance = distance
			
	return closest_unit


## Helper function to see if the enemy is done with its turn
func check_finished():
	for unit in units.enemy_units:
		# If a unit remains not moved, game is not finished
		if !unit.moved or !unit.took_action:
			return false
		# Otherwise turn is not over
		else:
			return true
	
