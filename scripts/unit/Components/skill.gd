extends Node

class_name Skill

var profession: Profession
# Targetable distance
var range: int
var damage: int
# What can be targetted with this skill?
enum targets {Cell, Unit}
@export var target: targets

# What is the area that this skill covers
enum area_shapes {LINE, SQUARE, CIRCLE, CONE}

var area_size: int
