extends StaticBody

const CHUNK_SIZE: int = 16
const CS1 = CHUNK_SIZE + 1
const TILE_SIZE: float = 2.0
const MATERIAL = preload("res://floor/floor2.material")

export(float) var _collision_margin = .15

onready var _mesh = $Mesh
onready var _collision = $CollisionShape


func _ready() -> void:
	var data = _generate_data()
	_generate_mesh(data)
	_generate_collisions(data)
	return


func _generate_data() -> PoolRealArray:
	# initialise noise
	var noise = OpenSimplexNoise.new()
	noise.seed = 0
	noise.octaves = 3
	noise.period = 32
	# sample noise
	var data = PoolRealArray()
	for  z in range(CS1):
		for x in range(CS1):
			var value = noise.get_noise_2d(x, z)
			value = round(value * 100) / 100  # round to 2sf for pixel perfect
			data.push_back(value)
	return data


func _generate_mesh(data: PoolRealArray) -> void:
	# generate vertices
	var vertices = PoolVector3Array()
	var normals = PoolVector3Array()
	var uvs = PoolVector2Array()
	var uv_array = PoolVector2Array([Vector2.ZERO, Vector2.RIGHT, Vector2.DOWN, Vector2.RIGHT, Vector2.ONE, Vector2.DOWN])
	for z in range(CHUNK_SIZE):
		for x in range(CHUNK_SIZE):
			uvs.append_array(uv_array)  # uvs
			for n in range(6):  # normals
				normals.push_back(Vector3.UP)
			vertices.append_array(_get_vertices(x, z, data))
	# generate array mesh
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_NORMAL] = normals
	arrays[ArrayMesh.ARRAY_TEX_UV] = uvs
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	array_mesh.surface_set_material(0, MATERIAL)
	_mesh.mesh = array_mesh
	return


func _generate_collisions(data: PoolRealArray) -> void:
	# position collision shape
	_collision.scale = Vector3.ONE * TILE_SIZE
	_collision.transform.origin = Vector3(CHUNK_SIZE, 0, CHUNK_SIZE) * TILE_SIZE / 2
	# generate height map shape
	var height_map_shape = HeightMapShape.new()
	height_map_shape.map_width = CS1
	height_map_shape.map_depth = CS1
	height_map_shape.map_data = data
	height_map_shape.margin = _collision_margin
	_collision.shape = height_map_shape
	return


func _get_vertices(x: int, z: int, data: PoolRealArray) -> PoolVector3Array:
	var offsets = PoolVector3Array()
	for offset in [Vector2.ZERO, Vector2.RIGHT, Vector2.DOWN, Vector2.ONE]:
		var ox = x + offset.x
		var oz = z + offset.y
		offsets.push_back(Vector3(ox, data[oz * CS1 + ox], oz) * TILE_SIZE)
	var new_vertices = PoolVector3Array()
	for o in [0, 1, 2, 1, 3, 2]:
		new_vertices.push_back(offsets[o])
	return new_vertices
