extends Reference
class_name Modifier

enum ModifierType {
	FLAT = 100,
	PERCENT_ADD = 200,
	PERCENT_MULTIPLY = 300,
}

var _value: float
var _type: int
var _order: int # modifier apply order
var _source: Object

func _init(value: float, type: int, order: int, source: Object) -> void:
	_value = value
	_type = type
	_order = order
	_source = source
	return


func get_value() -> float:
	return _value


func get_type() -> int:
	return _type


func get_source() -> Object:
	return _source


func sort(a: Modifier, b: Modifier) -> bool:
	if a._order < b._order:
		return true
	return false
