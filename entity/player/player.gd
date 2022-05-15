extends KinematicBody
class_name Player

const GRAVITY = Vector3.DOWN * 9.8
const UP = Vector3.UP
const SNAP = Vector3.DOWN

var _health: Stat = Stat.new(100)
var _velocity: Vector3


func _physics_process(delta: float) -> void:
	# add gravity
	_velocity += GRAVITY * delta
	# apply velocity
	_velocity = move_and_slide_with_snap(_velocity, _get_snap(), UP, true)
	# handle collisions (slides)
	for s in get_slide_count():
		var collision = get_slide_collision(s)
		var dot = collision.normal.dot(UP)
	return


func _get_snap() -> Vector3:
	return SNAP if is_on_floor() else Vector3.ZERO
