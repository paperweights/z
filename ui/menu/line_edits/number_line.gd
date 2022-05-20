class_name NumberLine
extends ValidLine

export (int) var _max


func _valid_text(new_text: String) -> bool:
	for character in new_text:
		# only allow digits
		if not character in '0123456789':
			return false
	# limit max port
	if int(new_text) > _max:
		return false
	return true
