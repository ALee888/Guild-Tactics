extends Control
@onready var action_handler: Node2D = %ActionHandler
@onready var selection_handler: Node2D = %SelectionHandler
@onready var confirm_button: Button = $Panel/VBoxContainer/ConfirmButton


var selected_action: Skill


func cancel_action() -> void:
	Game.set_game_state(Game.game_states.PLAYER_TURN)
	#action_handler.selected_action = null
	selected_action = null
	confirm_button.visible = false
	%Overlay.clear()


## On UI button press, initiate weapon attack
func _on_weapon_attack_pressed() -> void:
	# TODO: Correspond button press with skill rather than searching by name
	var unit = selection_handler.selected_unit
	if unit:
		var weapon_attack = unit.skills.find_child("WeaponAttack")
		if weapon_attack:
			# Set the action handler to the selected action
			selected_action = weapon_attack
			#action_handler.selected_action = weapon_attack
			# Display UI for targetting with the weapon
			%Overlay.show_targettable_units(unit.current_tile, weapon_attack.range)
			%Overlay.build_combat_range(weapon_attack.range, unit.current_tile)
			# Set the state to targetting to allow user to target
			Game.set_game_state(Game.game_states.TARGETING)
		else:
			print("error: weapon attack skill could not be found in: ", selection_handler.selected_unit.name)


func _on_confirm_button_pressed() -> void:
	action_handler.action(selected_action)
	confirm_button.visible = false
	
	%Overlay.clear()


func _on_pass_button_pressed() -> void:
	action_handler.pass_unit()


func _on_selection_handler_unit_selected(selected_unit: Unit) -> void:
	# TODO: Get unit skills
	# Rename buttons
	%WeaponAttack.text = selected_unit.inventory.equipted_weapon.name
