class_name AsciiLine
extends ValidLine

export (bool) var _lowercase = false

const ASCII = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

func _valid_text(new_text: String) -> bool:
	for ascii in new_text:
		if not ascii in ASCII:
			return false
	if _lowercase:
		var pos = caret_position
		text = new_text.to_lower()
		caret_position = pos
	return true
