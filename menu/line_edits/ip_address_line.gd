class_name IpAddressLine
extends ValidLine


func _valid_text(new_text: String) -> bool:
	var num = 3
	var dot = false
	var dots = 0
	for character in new_text:
		# handle dots
		if character == '.':
			if dots >= 3:
				return false
			if not dot:
				return false
			else:
				dot = false
				num = 3
				dots += 1
		# handle numbers
		elif character in '0123456789':
			if num <= 0:
				return false
			else:
				num -= 1
				dot = true
		else:
			return false
	return true
