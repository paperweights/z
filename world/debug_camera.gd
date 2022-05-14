extends Camera

export(float) var _speed = 3.0

var _mouse_offset: Vector2
var _active: bool


func _input(event) -> void:
	if event.is_action_pressed("camera_toggle"):
		_active = !_active
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if _active else Input.MOUSE_MODE_VISIBLE)
	if !_active:
		return
	if event is InputEventMouseMotion:
		_mouse_offset -= event.relative
	return


func _process(delta: float) -> void:
	if !_active:
		return
	# rotate
	rotate_y(delta * _mouse_offset.x)
	rotate_object_local(Vector3.RIGHT, delta * _mouse_offset.y)
	_mouse_offset = Vector2.ZERO  # prevent mouse offset buildup
	# translate
	var input = Vector2(
		-Input.get_action_strength("camera_left") + Input.get_action_strength("camera_right"),
		-Input.get_action_strength("camera_forward") + Input.get_action_strength("camera_backward")
	)
	var offset = input.x * transform.basis.x + input.y * transform.basis.z
	transform.origin += delta * _speed * offset
	return
