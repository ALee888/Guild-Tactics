extends Node2D

@onready var tile_map: TileMapLayer = %TileMap
@onready var units: Node2D = $"../Units"
@onready var selection_handler: Node2D = $"../SelectionHandler"
@onready var movement_handler: Node2D = %MovementHandler

var selected_action: Skill
var target_unit: Unit

signal action_complete


## When the user right clicks a tile, execute movement or basic weapon attack depending on if the square has a target or not.
func action_click():
	var target_tile: Vector2i = tile_map.local_to_map(get_global_mouse_position())
	#print("Action targetting: ", target_tile)
	# Get unit that will execute the action
	var selected_unit = selection_handler.selected_unit
	# Check if a unit is selected
	if selected_unit and selected_unit.unit_type == Unit.unit_types.PLAYER:
		# Look and see what is in the tile
		var target_unit = units.get_tile(target_tile)
		# If there is a unit targetted, then explore options
		if target_unit:
			print('target_unit: ', target_unit)
			 #Execute attack action on unit and check for outcome
			if Combat.weapon_attack(selected_unit, target_unit):
				# Unit has made it's move, now deselect
				selected_unit.took_action = true
				selected_unit.deselect() # TODO: Change logic to match how many moves unit can make on a turn
				action_complete.emit()
			else:
				# Attack failed
				return false
		else:
			# Execute move action on unit and check for outcome
			return movement_handler.move(selected_unit, target_tile)
	# No unit is selected so no action can be done
	else:
		print("No unit is selected")
		return false


## When user selects (L-click) an enemy to target, return true or false if it is a valid enemy
func target() -> bool:
	if !selected_action:
		print("No action selected in target()")
		return false
	var target_tile: Vector2i = tile_map.local_to_map(get_global_mouse_position())
	# Check if target is within range of action
	# NOTE: Assume a unit is selected
	if Pathing.calc_h_cost(selection_handler.selected_unit.current_tile, target_tile) <= selected_action.range:
		target_unit = units.get_tile(target_tile)
		# TODO: Check if target type matches selected_action.target_type
		
		# Return true if tile holds a unit and is an enemy
		if target_unit and target_unit.unit_type == Unit.unit_types.ENEMY:
			return true
		else:
			print("Target unit not found at tile")
			return false
	else:
		print("Target tile too far")
		return false
	return true


## Execute a combat or unit action
func action() -> void:
	# 3 parts to an aciton:
	# 1. Selected unit
	var selected_unit = selection_handler.selected_unit
	print(selected_unit.name, " will ", selected_action.name, " ",  target_unit.name)
	# 2. The action
	if selected_action is Skill:
		# TODO: Check type. (Attack, buff, debuf, etc)
		Combat.attack(selected_unit, selected_action, target_unit)


func unit_hotbar(button_num: int):
	var unit = selection_handler.selected_unit
	#if unit.equipted_weapon
		#ch button_num:
			#1: # Use main weapon
				## TODO: if buton already pressed, trigger attack
				## Draw range indicator
				#unit.unit_ui.build_combat_range(unit.combat.weapon, unit.current_tile)
				## TODO: ready weapon animation 

func _on_movement_handler_movement_complete() -> void:
	action_complete.emit()
	
