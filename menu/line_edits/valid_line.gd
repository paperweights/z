class_name ValidLine
extends LineEdit

signal changed(new_text)

var _text: String
var _caret_position: int


func _ready():
	connect("text_changed", self, "_on_text_changed")
	return


func _on_text_changed(new_text: String):
	# reset if new text is not valid
	if not _valid_text(new_text):
		text = _text
		caret_position = _caret_position
		return
	# update if otherwise
	_text = text
	_caret_position = caret_position
	emit_signal("changed", new_text)
	return


func _valid_text(_new_text: String) -> bool:
	return false
