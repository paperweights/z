class_name AsciiLine
extends ValidLine


func _valid_text(new_text: String) -> bool:
	for ascii in new_text.to_ascii():
		if ascii > 127:
			return false
	return true
