extends Node
	
	
func validate_action(action, attacker: Unit, defender: Unit):
	# Validate if action can be taken
	if !attacker.took_action:
		# Validate target
		#if defender.unit_type == attack.target_type: #TODO: Give attack a type
		if attacker.unit_type != defender.unit_type:
			# Validate range
			if action.range >= Pathing.calc_h_cost(attacker.current_tile, defender.current_tile):
				return true
			else:
				print("Target is out of range")
		else:
			print("Target is not valid")
			return false
	else:
		print("already took action")
		return false
		
func get_targetable_tiles(current_tile: Vector2i, weapon_range: int):
	# Using weapon range
	var directions = [
		Vector2i(1, 0), #right
		Vector2i(0, 1), # Down
		Vector2i(-1, 0), # Left
		Vector2i(0,-1) # Up
	]
	var tiles = []
	print("weapon range: ", weapon_range)
	for direction in directions:
		for i in range(1, weapon_range+1):
			tiles.append(current_tile+(direction*i))
	print("targetable_tiles: ", tiles)
	return tiles


## Perform the attack skill on the defender using the attacker's stats
func attack(attacker: Unit, attack: Skill, defender: Unit) -> void:
	# Calculate attack damage
	
	
func weapon_attack(attacker: Unit, defender: Unit):
	## Perform a basic attack with a weapon
	# Calculate attack damage
	var attack_dmg = 0
	print("Str: ", attacker.stats.str)
	# Check if weapon exists
	var weapon = attacker.inventory.equipted_weapon
	if weapon:
		if validate_action(weapon, attacker, defender):
			attacker.took_action = true
			# Perform attack
			print("Using ", weapon.name, " (", weapon.damage, ")")
			# TODO: Accuracy check
			attack_dmg = weapon.damage + attacker.stats.str
		else:
			return false
	# If not, use raw strength for unarmed attack
	else:
		attack_dmg = attacker.stats.str

	# Send damage to defender
	defend(defender, attack_dmg)
	# At this point weapon attack was successful and damage is applied
	return true

func defend(defender: Unit, damage: int):
	# TODO: accuracy check here?
	print("Old hp: ", defender.stats.hp)
	# Apply damage
	if defender.inventory.equipted_armor:
		defender.stats.hp -= (damage-defender.inventory.equipted_armor)
	else:
		defender.stats.hp -= damage
	print("New hp: ", defender.stats.hp)
	defender.stats.update_health_bar()
	check_death(defender)
	
	
func check_death(victim: Unit):
	if victim.stats.hp <= 0:
		print("Unit died")
		victim.queue_free()
		var unit_handler = get_node("../Units")
		unit_handler.set_units()
