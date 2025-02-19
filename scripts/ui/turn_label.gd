extends Label

func _process(delta: float) -> void:
	match Game.state:
		Game.game_states.PLAYER_TURN:
			text = "Player turn"
		Game.game_states.RESOLVING:
			text = "Resolving"
		Game.game_states.TARGETING:
			text = "Targeting..."
		Game.game_states.ENEMY_TURN:
			text = "Enemy Turn"

func change_label(new_text: String):
	text = new_text
