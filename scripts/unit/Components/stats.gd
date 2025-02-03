extends Node

@onready var health_bar: ProgressBar = get_node("../UnitSprite/HealthBar")

# TODO: Convert to dictionary if better
@export var unit_name: String
@export var max_hp: int = 3
@export var power: int = 1
@export var cunning: int = 1
@export var agility: int = 3

var hp: int = max_hp

var stats = {}

func _init() -> void:
	if !unit_name:
		generate_random_stats()


func generate_random_stats():
	unit_name = name
	max_hp = randi_range(5, 10)
	hp = max_hp
	power = randi_range(1, 5)
	cunning = randi_range(1, 5)
	agility = randi_range(1, 5)
	
	if health_bar:
		update_health_bar()
	
func update_health_bar():
	## Update healthbar values to match hp variables
	health_bar.max_value = max_hp
	health_bar.value = hp



func display() -> void:
	## Display stats to user
	print("---------------------")
	print("unit_name: ", unit_name)
	print("max_hp: ", max_hp)
	print("hp: ", hp)
	print("power: ", power)
	print("cunning: ", cunning)
	print("agility: ", agility)
	print("---------------------")
