extends Camera

export(NodePath) var _target_node
export(Vector3) var _offset

var _mouse_motion: Vector2
var _active: bool

onready var _target: Spatial = get_node(_target_node)


func _ready() -> void:
	set_active(true)
	return


func _input(event) -> void:
	# active toggle
	if event is InputEventKey and event.is_pressed() and event.scancode == KEY_ESCAPE:
		toggle_active()
	# skip if inactive
	if !_active:
		return
	# mouse movement
	if event is InputEventMouseMotion:
		_mouse_motion -= event.relative  # accumulate mouse motion
	return


func _process(delta: float) -> void:
	# rotate
	rotate_y(_mouse_motion.x * delta)
	rotate_object_local(Vector3.RIGHT, _mouse_motion.y * delta)
	var clamped_rotation = rotation_degrees
	clamped_rotation.x = clamp(clamped_rotation.x, -80, 80)
	rotation_degrees = clamped_rotation
	_mouse_motion = Vector2.ZERO  # reset mouse motion
	# translate
	var basis = transform.basis
	var offset = basis.x * _offset.x + basis.y * _offset.y + basis.z * _offset.z
	transform.origin = _target.transform.origin + offset
	return


func set_active(active: bool) -> void:
	_active = active
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if _active else Input.MOUSE_MODE_VISIBLE)


func toggle_active() -> void:
	_active = !_active
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if _active else Input.MOUSE_MODE_VISIBLE)
