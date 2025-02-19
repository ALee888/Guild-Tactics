extends Node2D

@onready var enemy_units: Node2D = $"../Units/EnemyUnits"
@onready var units: Node2D = $"../Units"

signal enemy_turn_over

## Game constants
const TILE_SIZE = 16
const ANIMATION_SPEED = 40

## Logic variables
var enemy_initiative = []
var selected_enemy = Unit
var instruction_queue = []


## Execute the instruction queue.
func _physics_process(delta: float) -> void:
	if Game.state == Game.game_states.ENEMY_TURN:
		# While there are instructions in the instruction_queue
		if instruction_queue:
			# Grab the 
			var next_instruction = instruction_queue.back()
			# If the instruction is coordinates, Move to the location
			if next_instruction is Vector2i:
				var next_position = Vector2(next_instruction) * TILE_SIZE
				# If the unit is farther from the tile than 1, move towards it
				if global_position.distance_to(next_position) > 1:
					global_position = global_position.move_toward(next_position, ANIMATION_SPEED * delta)
				# If the unit is close enough to the tile, snap to the center of it
				else:
					global_position = next_position
					selected_enemy.current_tile = instruction_queue.pop_back()
					# If the path is complete
					if instruction_queue.is_empty(): 
						if enemy_initiative.is_empty():
							enemy_turn_over.emit()
						make_move()
			# Otherwise, if the instruciton is a Unit, Attack that unit
			elif next_instruction is Skill:
				var action = instruction_queue.pop_back()
				var target = instruction_queue.pop_back()
				Combat.attack(selected_enemy, action, target)
				# Check if there are more moves to make
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
	selected_enemy = enemy_initiative.pop_front()
	print(selected_enemy.name, " making move")
	# Generate and execute instructions
	instruction_queue = get_instruction_queue(selected_enemy)
	print(instruction_queue)

## Return a list of instructions for the enemy to follow
func get_instruction_queue(enemy: Unit) -> Array: 
	#print(enemy.name, " is deciding best action")
	var queue = []
	# TODO: Different classes will have different behavior
	# Mindless units charge forward to the nearest enemy and attacks
	if enemy.tactics == enemy.enemy_tactics.MINDLESS:
		# Get target for the mindless unit
		var target = get_nearest_opponent(enemy.current_tile)
		var attack: Skill = enemy.find_child("WeaponAttack")
		# First check if target is able to get hit by player
		var targetable_tiles = Combat.get_targetable_tiles(enemy.current_tile, enemy.inventory.equipted_weapon.range)
		# If the target is within range, attack
		if target.current_tile in targetable_tiles:
			# TODO: Find better way to get skill other than findchild()
			queue.push_front([attack, target])
		# Otherwise, unit must move to get in range
		else:
			var movement_path = Pathing.get_movement_path(enemy.current_tile, target.current_tile)
			#print("movement path: ", movement_path)
			# Follow path and stop when unit is within range of target
			# TODO: OR stop when the unit cannot move further due to it's speed/agility stat
			while movement_path:
				var next_tile = movement_path.pop_back()
				# Check if the target is now in range
				if target.current_tile in Combat.get_targetable_tiles(next_tile, enemy.inventory.equipted_weapon.range):
					queue.push_front(attack)
					queue.push_front(target)
					# end queue because unit attack
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
	
