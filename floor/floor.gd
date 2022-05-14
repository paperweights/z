extends MeshInstance

const CHUNK_SIZE: int = 8
const TILE_SIZE: float = 2.0
const MATERIAL = preload("res://floor/floor2.material")


func _ready() -> void:
	var data = _generate_data()
	_generate_mesh(data)
	return


func _generate_data() -> PoolRealArray:
	# initialise noise
	var noise = OpenSimplexNoise.new()
	noise.seed = 0
	noise.octaves = 2
	noise.period = CHUNK_SIZE
	noise.persistence = CHUNK_SIZE
	# sample noise
	var data = PoolRealArray()
	for  z in range(CHUNK_SIZE + 1):
		for x in range(CHUNK_SIZE + 1):
			data.push_back(noise.get_noise_2d(x, z))
	return data


func _generate_mesh(data: PoolRealArray) -> void:
	# generate vertices
	var vertices = PoolVector3Array()
	var normals = PoolVector3Array()
	var uvs = PoolVector2Array()
	var uv_array = PoolVector2Array([Vector2.ZERO, Vector2.RIGHT, Vector2.DOWN, Vector2.RIGHT, Vector2.ONE, Vector2.DOWN])
	for z in range(CHUNK_SIZE):
		for x in range(CHUNK_SIZE):
			uvs.append_array(uv_array)
			for n in range(6):
				normals.push_back(Vector3.UP)
			var offsets = get_offsets(x, z, data)
			vertices.push_back(offsets[0] * TILE_SIZE)
			vertices.push_back(offsets[1] * TILE_SIZE)
			vertices.push_back(offsets[2] * TILE_SIZE)
			vertices.push_back(offsets[1] * TILE_SIZE)
			vertices.push_back(offsets[3] * TILE_SIZE)
			vertices.push_back(offsets[2] * TILE_SIZE)
	# generate array mesh
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_NORMAL] = normals
	arrays[ArrayMesh.ARRAY_TEX_UV] = uvs
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	array_mesh.surface_set_material(0, MATERIAL)
	mesh = array_mesh
	return


func get_offsets(x: int, z: int, data: PoolRealArray) -> PoolVector3Array:
	var offsets = PoolVector3Array()
	for offset in [Vector2.ZERO, Vector2.RIGHT, Vector2.DOWN, Vector2.ONE]:
		var ox = x + offset.x
		var oz = z + offset.y
		offsets.push_back(Vector3(ox, data[oz * CHUNK_SIZE + ox], oz))
	return offsets
