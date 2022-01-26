class_name PortLine
extends ValidLine


func _valid_text(new_text: String) -> bool:
	for character in new_text:
		# only allow digits
		if not character in '0123456789':
			return false
	# limit max port
	if int(new_text) > GameState.MAX_PORT:
		return false
	return true
