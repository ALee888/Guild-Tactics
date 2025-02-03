extends Camera2D
@onready var selection_handler: Node2D = $"../SelectionHandler"

# Minimum and maximum zoom limits
var min_zoom: float = 2
var max_zoom: float = 5.0

## Zoom speed factor
var zoom_speed: float = 0.1

## Start with a default zoom level
var current_zoom: float = 3.5

## Speed at which the camera scrolls
var scroll_speed = 200

## Distance from the edge to trigger a scroll
var edge_distance = 10
func _ready():
	zoom = Vector2(current_zoom, current_zoom)
	selection_handler.unit_selected.connect(_on_unit_selected)

func _on_unit_selected(unit):
	global_position = unit.global_position
	#print(get_screen_center_position())
	#print(global_position)

func _process(delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	var mouse_position = get_viewport().get_mouse_position()
	var movement = Vector2()
	
	if mouse_position.x <= edge_distance:
		movement.x -= 1
	elif mouse_position.x >= viewport_size.x - edge_distance:
		movement.x += 1
	
	if mouse_position.y <= edge_distance:
		movement.y -= 1
	elif mouse_position.y >= viewport_size.y - edge_distance:
		movement.y += 1
	
	if movement != Vector2.ZERO:
		position += movement.normalized() * scroll_speed * delta

func _input(event):
	# Zoom in with the mouse wheel up
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and current_zoom > min_zoom:
			current_zoom -= zoom_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and current_zoom < max_zoom:
			current_zoom += zoom_speed
		
		# Apply the zoom to the Camera2D node
		zoom = Vector2(current_zoom, current_zoom)
		queue_redraw()
