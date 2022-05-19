extends KinematicBody
class_name Player

const GRAVITY = Vector3.DOWN * 9.8
const UP = Vector3.UP
const SNAP = Vector3.DOWN
const FLOOR_MAX_ANGLE = deg2rad(52)
const MESH_ROTATION_SPEED = 0.15

export(float) var _speed = 100
export(float) var _jump_foce = 5

var _health: Stat = Stat.new(100)
var _velocity: Vector3
var _jumping: bool = false

onready var _camera = $CameraBase
onready var _mesh = $Mesh


func _physics_process(delta: float) -> void:
	# movement
	# horizontal
	_velocity.x = 0
	_velocity.z = 0
	var input = _get_input()
	_velocity += delta * _speed * _get_target_horizontal_velocity(input)
	# jumping
	if Input.is_action_just_pressed("player_jump") and !_jumping:
		_jumping = true
		_velocity.y = _jump_foce
	# add gravity
	else:
		_velocity += GRAVITY * delta
	# apply velocity
	_velocity = move_and_slide_with_snap(_velocity, _get_snap(), UP, _get_slide(), 4, FLOOR_MAX_ANGLE)
	# handle collisions (slides)
	for s in get_slide_count():
		var collision = get_slide_collision(s)
		var dot = collision.normal.dot(UP)
		if dot > 0.98:
			_jumping = false
	# rotate mesh
	if abs(_velocity.x) + abs(_velocity.z) >= 0.1:
		_mesh.rotation.y = lerp_angle(_mesh.rotation.y, atan2(_velocity.x, _velocity.z), MESH_ROTATION_SPEED)
	return


func _get_input() -> Vector2:
	return Vector2(
		-Input.get_action_strength("player_left") + Input.get_action_strength("player_right"),
		-Input.get_action_strength("player_forward") + Input.get_action_strength("player_backward")
	)


func _get_target_horizontal_velocity(horizontal_input: Vector2) -> Vector3:
	var camera_basis = _camera.transform.basis
	# normalise bases
	# x
	var camera_x = camera_basis.x
	camera_x.y = 0
	camera_x = camera_x.normalized() * horizontal_input.x
	# z
	var camera_z = camera_basis.z
	camera_z.y = 0
	camera_z = camera_z.normalized() * horizontal_input.y
	return camera_x + camera_z


func _get_snap() -> Vector3:
	return SNAP if !_jumping else Vector3.ZERO


func _get_slide() -> bool:
	return abs(_velocity.x) + abs(_velocity.z) <= 0
