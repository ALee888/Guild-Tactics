extends Node

## States for the game
enum game_states {PLAYER_TURN, ENEMY_TURN, RESOLVING, MENU, TARGETING}
var state: game_states = game_states.MENU


func set_game_state(new_state: game_states):
	match new_state:
		game_states.MENU:
			if state == game_states.PLAYER_TURN or state == game_states.ENEMY_TURN:
				state = game_states.MENU
		game_states.PLAYER_TURN:
			# Player turn can be set from any state
			state = game_states.PLAYER_TURN
		game_states.ENEMY_TURN:
			if state == game_states.PLAYER_TURN or state == game_states.RESOLVING:
				state = game_states.ENEMY_TURN
		game_states.RESOLVING:
			if state == game_states.PLAYER_TURN or state == game_states.ENEMY_TURN:
				state = game_states.RESOLVING
		game_states.TARGETING:
			if state == game_states.PLAYER_TURN:
				state = new_state
