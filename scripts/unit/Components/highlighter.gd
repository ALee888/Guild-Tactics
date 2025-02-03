extends Line2D
	
func highlight(selected: bool, unit_type: Unit.unit_types):
	# ffff28af - yellow
	# 69ff5faf - Green
	visible = true
	if unit_type == Unit.unit_types.ENEMY:
		if selected:
			set_default_color("red")
		else:
			set_default_color("ff8628af") #Orange
	else:
		if selected:
			set_default_color("69ff5faf")
		else:
			set_default_color("ffff28af")
