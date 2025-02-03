extends Sprite2D

@onready var tile_map: TileMapLayer = %TileMap

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var target_tile: Vector2i = tile_map.local_to_map(get_global_mouse_position())
		global_position = tile_map.map_to_local(target_tile)
