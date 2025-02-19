extends CharacterBody2D

class_name Unit

# References
@onready var highlighter: Line2D = get_node("UnitSprite/Highlighter")
@onready var health_bar: ProgressBar = $HealthBar
@onready var stats: Node = $Stats
@onready var inventory: Node = $Inventory
@onready var skills: Node = $Skills


# Unit Properties
enum unit_types {NEUTRAL, PLAYER, FRIENDLY, ENEMY}
enum unit_states {MOVING, ATTACKING, READY, IDLE, TARGETING}
@export var unit_type: unit_types
var state: unit_states = unit_states.IDLE # Start IDLE and don't activate until game start
@onready var current_tile: Vector2i = Vector2i(global_position/16)
var selected = false


# Turn controllers
var moved = false
var took_action = false

func deselect():
	highlighter.visible = false
	selected = false



func update_healthbar():
	## Update healthbar values to match hp variables
	health_bar.max_value = stats.max_hp
	health_bar.value = stats.hp

## When the mouse exits the unit, remove the highlight unless the unit is highlighted
func _on_mouse_exited() -> void:
	if !selected:
		highlighter.visible = false

## When the mouse enters the unit, highlight the unit with the unit type and selected bool
func _on_mouse_entered() -> void:
	highlighter.highlight(selected, unit_type)
