extends Node2D

@export var weapon: Equipment
@export var armor: Equipment
@onready var stats: Node = $"../Stats"
@onready var pathing: Node = $Pathing
func attack(target: Unit):
	
	# Calculate attack damage
	var attack_dmg = 0
	print("Str: ", stats.str)
	# Check if weapon exists
	if weapon:
		# TODO: Check weapon range
		
		# Check weapon range
		if weapon.range >= pathing.get_h_cost(Vector2i(global_position/16), target.current_tile):	
			print("Using ", weapon.name, " (", weapon.damage, ")")
			# TODO: Accuracy check
			attack_dmg = weapon.damage + stats.str
		else:
			print("weapon is out of range")
	# If not, use raw strength for unarmed attack
	else:
		attack_dmg = stats.str
	
	# Send damage to target
	target.combat.defend(attack_dmg)
	

func defend(damage):
	# TODO: accuracy check here?
	print("Old hp: ", stats.hp)
	# Apply damage
	if armor:
		stats.hp -= (damage-armor)
	else:
		stats.hp -= damage
	print("New hp: ", stats.hp)
	stats.update_health_bar()
	if stats.hp <= 0:
		print("Unit died")
		get_parent().queue_free()
