@tool

extends RectHexGrid

@export var noise : FastNoiseLite

@export var height_scale : float = 5.0
@export var noise_scale : float = 1.0


func get_heightmap_from_noise(hex : HexMesh, noise : FastNoiseLite):
	var result : PackedVector3Array
	var vertices = hex.get_vertices()
	for v : Vector3 in vertices:
		result.append(Vector3(v.x, noise.get_noise_2d(v.x * noise_scale, v.z * noise_scale), v.z * height_scale))
	return result

func _ready() -> void:
	for hex : SotaMesh in get_hex_meshes():
		hex.set_vertices(get_heightmap_from_noise(hex, noise))

func _process(_delta: float) -> void:
	pass
