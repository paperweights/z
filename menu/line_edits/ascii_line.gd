class_name AsciiLine
extends ValidLine

const ASCII = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

func _valid_text(new_text: String) -> bool:
	for ascii in new_text:
		if not ascii in ASCII:
			return false
	return true
