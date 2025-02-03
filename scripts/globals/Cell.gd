extends Object

class_name Cell

var position: Vector2i
var parent: Cell = null # parent cell in the path
var g_cost: int
var h_cost: int
var f_cost: int

# Constructor
func _init(position: Vector2=Vector2(), parent: Cell=null, g_cost=0, h_cost=0):
	self.position = position
	self.parent = parent
	self.g_cost = g_cost
	self.h_cost = h_cost
	self.f_cost = g_cost + h_cost

# Helper function to update F-cost (G-cost + H-cost)
func update_f_cost():
	f_cost = g_cost + h_cost
