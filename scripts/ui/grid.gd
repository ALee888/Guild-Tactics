extends Node2D
# Size of each grid cell
var grid_size = 16

func _draw():
	var viewport_size = get_viewport_rect().size

	for x in range(0, int(viewport_size.x / grid_size)):
		draw_line(Vector2(x * grid_size, 0), Vector2(x * grid_size, viewport_size.y), Color(0.5, 0.5, 0.5))
	
	for y in range(0, int(viewport_size.y / grid_size)):
		draw_line(Vector2(0, y * grid_size), Vector2(viewport_size.x, y * grid_size), Color(0.5, 0.5, 0.5))
