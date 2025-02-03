extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func clear_ui() -> void:
	%Overlay.clear()

func display_movement_range(unit_speed: int, current_tile: Vector2i) -> void:
	%Overlay.build_range(unit_speed, current_tile)
		
func display_combat_range(weapon, current_tile: Vector2i) -> void:
	%Overlay.build_combat_range(weapon, current_tile)
