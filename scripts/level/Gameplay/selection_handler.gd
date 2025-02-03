extends Node2D
@onready var tile_map: TileMapLayer = %TileMap
@onready var units: Node2D = $"../Units"
signal unit_selected

var selected_unit: Unit

## Called on l-click and handles player selection of objects and units in the level
func select() -> void:
	var unit = units.get_tile(tile_map.local_to_map(get_global_mouse_position()))
	# Check if a unit was clicked
	if unit:
		# If unit is already selected inform user or ignor
		if unit.selected:
			print("Unit already selected")
		# Otherwise, unit not already selected
		else:
			# Deselect all units
			deselect()
			
			# Update UI
			if !unit.moved:
				%Overlay.build_range(unit.stats.agility, unit.current_tile)
			if !unit.took_action:
				%ActionBar.visible = true
			else:
				%ActionBar.visible = false
			# Set selected to true
			unit.selected = true
			selected_unit = unit
			# Emit currently used by (Camera2D)
			unit_selected.emit(unit)
			
			# Reset highlight
			unit.highlighter.highlight(true, unit.unit_type)
	# TODO: elif tile was clicked, give info on the tile!
	else:
		# No unit was clicked so deselect other units
		deselect()
	
	print("Selected unit: ", selected_unit)

## Deselects all units
func deselect():
	# Set each unit to deselected
	for unit in units.player_units:
		unit.deselect()
	for unit in units.enemy_units:
		unit.deselect()
	# Reset selected unit
	selected_unit = null
	# clear the ui
	%UnitUI.clear_ui()
	%ActionBar.visible = false
	
	
