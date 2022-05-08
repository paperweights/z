extends Reference
class_name Stat

export(float) var _base_value

var _modifiers: Array
var _last_value: float # caches final value
var _dirty: bool # tracks if final value needs to be recalculated


func _init(base_value: float) -> void:
	_base_value = base_value
	_modifiers = []
	return


func add_modifier(modifier: Modifier) -> void:
	_dirty = true
	_modifiers.push_back(modifier)
	_modifiers.sort_custom(Modifier, "sort")
	return


func remove_modifier(modifier: Modifier) -> void:
	_dirty = true
	_modifiers.erase(modifier)
	return


func remove_from_source(source: Object) -> void:
	for m in range(_modifiers.size() - 1, -1, -1):
		if _modifiers[m].get_source() == source:
			_modifiers.remove(m)


# return final value
func get_value() -> float:
	# return cached value if modifiers haven't changed
	if not _dirty:
		return _last_value
	var final_value = _base_value
	var percent_add_sum = 0.0
	# calculate modifiers
	for m in range(_modifiers.size()):
		var modifier: Modifier = _modifiers[m]
		var type: int = modifier.get_type()
		match type:
			Modifier.ModifierType.FLAT:
				final_value += modifier.get_value()
			Modifier.ModifierType.PERCENT_ADD:
				percent_add_sum += modifier.get_value()
				if m + 1 >= _modifiers.size() or _modifiers[m + 1].get_type() != Modifier.ModifierType.PERCENT_ADD:
					final_value *= 1 + percent_add_sum
			Modifier.ModifierType.PERCENT_MULTIPLY:
				final_value *= 1 + modifier.get_value()
	# cache final value
	_dirty = false
	# round to 4 sf
	_last_value = round(final_value * 100) / 100
	return _last_value
