extends Node2D


## Units
@onready var unit_handler: Node2D = $Units
@onready var enemy_handler: Node = $EnemyHandler

## Component references
@onready var tile_map: TileMapLayer = %TileMap
@onready var game_ui: CanvasLayer = $GameUI

@onready var selection_handler: Node2D = $SelectionHandler
@onready var action_handler: Node2D = $ActionHandler

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	start_player_turn()

## Initializes Player turn while providing user feedback
func start_player_turn() -> void:
	print("starting player turn")
	# Set game state
	Game.set_game_state(Game.game_states.PLAYER_TURN)
	# Initialize units to await for input
	unit_handler.reset_units(Unit.unit_types.PLAYER)
	
func start_enemy_turn() -> void:
	# TODO: If there are no more enemy units then player wins
	#Game.set_game_state(game_states.RESOLVING)
	unit_handler.reset_units(Unit.unit_types.ENEMY)
	enemy_handler.start_turn()


## Function to play
func _on_player_move_made() -> void:
	print("move made")
	# Check if the player can make any more moves
	if unit_handler.check_finished():
		# Player has no more moves, start enemy turn
		start_enemy_turn()
	else:
		# Player can make more moves, reset state so player can make inputs
		Game.set_game_state(Game.game_states.PLAYER_TURN)


## Function to catch signal from the Action handler. This indicates that a move has just been made and to check if the player can make any more moves
func _on_action_handler_action_complete() -> void:
	# Only make moves
	#if game_state == game_states.PLAYER_TURN:
	print("move made")
	# Check if the player can make any more moves
	if unit_handler.check_player_finished():
		print("Player finished")
		# Player has no more moves, start enemy turn
		start_enemy_turn()
	else:
		print("Player can make more moves")
		# Player can make more moves, set state back to player so more moves can be made
		Game.set_game_state(Game.game_states.PLAYER_TURN)


func _on_enemy_turn_over() -> void:
	print("enemy finished")
	start_player_turn()


func _unhandled_input(event: InputEvent) -> void:
	#set_process_unhandled_input(true)
	# L-click: Does different things
	if event.is_action_pressed("Select"):
		# Check if the event has already been handled by a button
			match Game.state:
				Game.game_states.PLAYER_TURN:
					selection_handler.select()
				Game.game_states.TARGETING:
					# TODO: Targeting
					if action_handler.target():
						%ActionBar.confirm_button.visible = true

	elif event.is_action_pressed("Action"):
		match Game.state:
			Game.game_states.PLAYER_TURN:
				# Check if action is valid
				if action_handler.action_click():
					%Overlay.clear()
					# Set game state to resolving. User cannot input while action finishes
					Game.set_game_state(Game.game_states.RESOLVING)
					# NOTE: Game state will be set back to player turn in a signal once action is complete
			Game.game_states.TARGETING:
				# TODO: close confirm button
				# Cancel current ability targetting
				%ActionBar.cancel_action()
			Game.game_states.MENU:
				# TODO: Close current menu
				pass
	# Enter: Start game
	elif event.is_action_pressed("Start"): # Temporary simulating start of game
		# TODO: State handling
		print("start")
	elif event.is_action_pressed("Cancel"):
		# TODO: State handling
		selection_handler.deselect()
		if Game.state == Game.game_states.TARGETING:
			%ActionBar.cancel_action()
	# Check for action hotbar key presses
	else:
		# TODO: all hotkey bars
		if event.is_action_pressed("Action_1"):
			action_handler.unit_hotbar(1)
			# TODO
			# 1. Match hotbar key (1 in this case) with ability in ui]
			# 2. Select action and start targetting
