class_name PortLine
extends ValidLine

# https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
const MIN_PORT = 1
const MAX_PORT = 49151

func _valid_text(new_text: String) -> bool:
	for character in new_text:
		# only allow digits
		if not character in '0123456789':
			return false
	# limit max port
	if int(new_text) > MAX_PORT:
		return false
	return true
