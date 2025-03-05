class_name OutlineManager
extends Node3D

# List of all outline hexagons
var outline_hexagons = []
var current_outline_hexagon = null

# Constants for hexagon generation
const HEX_SIZE = 1.0
const HEX_OUTLINE_HEIGHT = 0.1
const HEX_OUTLINE_THICKNESS = 0.05

func _ready():
	# Add the initial hexagon outline at center position
	add_outline_hexagon(Vector3(0, 0, 0))

func add_outline_hexagon(position: Vector3):
	# Create a mesh instance for the hex outline
	var hex_outline = MeshInstance3D.new()
	
	# Create the hex outline mesh
	var mesh = create_hex_outline_mesh()
	hex_outline.mesh = mesh
	
	# Add to the scene
	hex_outline.position = position
	add_child(hex_outline)
	
	# Add to our list of outline hexagons
	outline_hexagons.append(hex_outline)
	current_outline_hexagon = hex_outline
	
	# Add collision shape for raycasting
	var static_body = StaticBody3D.new()
	var collision_shape = CollisionShape3D.new()
	var shape = CylinderShape3D.new()
	shape.height = HEX_OUTLINE_HEIGHT
	shape.radius = HEX_SIZE
	collision_shape.shape = shape
	static_body.add_child(collision_shape)
	hex_outline.add_child(static_body)
	
	return hex_outline

func create_hex_outline_mesh() -> Mesh:
	# Create an ArrayMesh for the hex outline
	var arr_mesh = ArrayMesh.new()
	
	# Vertices for a regular hexagon
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	
	# Create the hexagon outline (a hollow hexagonal prism)
	for i in range(6):
		var angle_deg = i * 60.0
		var angle_rad = deg_to_rad(angle_deg)
		var x = HEX_SIZE * cos(angle_rad)
		var z = HEX_SIZE * sin(angle_rad)
		
		# Bottom vertices (inner and outer)
		vertices.append(Vector3(x, 0, z))
		vertices.append(Vector3(x * (1 + HEX_OUTLINE_THICKNESS), 0, z * (1 + HEX_OUTLINE_THICKNESS)))
		
		# Top vertices (inner and outer)
		vertices.append(Vector3(x, HEX_OUTLINE_HEIGHT, z))
		vertices.append(Vector3(x * (1 + HEX_OUTLINE_THICKNESS), HEX_OUTLINE_HEIGHT, z * (1 + HEX_OUTLINE_THICKNESS)))
	
	# Create triangles for the hexagon outline
	for i in range(6):
		var next_i = (i + 1) % 6
		
		# Indices for current corner
		var bottom_inner = i * 4
		var bottom_outer = i * 4 + 1
		var top_inner = i * 4 + 2
		var top_outer = i * 4 + 3
		
		# Indices for next corner
		var next_bottom_inner = next_i * 4
		var next_bottom_outer = next_i * 4 + 1
		var next_top_inner = next_i * 4 + 2
		var next_top_outer = next_i * 4 + 3
		
		# Bottom face
		indices.append(bottom_inner)
		indices.append(next_bottom_inner)
		indices.append(bottom_outer)
		
		indices.append(bottom_outer)
		indices.append(next_bottom_inner)
		indices.append(next_bottom_outer)
		
		# Top face
		indices.append(top_inner)
		indices.append(top_outer)
		indices.append(next_top_inner)
		
		indices.append(top_outer)
		indices.append(next_top_outer)
		indices.append(next_top_inner)
		
		# Outer side face
		indices.append(bottom_outer)
		indices.append(next_bottom_outer)
		indices.append(top_outer)
		
		indices.append(next_bottom_outer)
		indices.append(next_top_outer)
		indices.append(top_outer)
		
		# Inner side face
		indices.append(bottom_inner)
		indices.append(top_inner)
		indices.append(next_bottom_inner)
		
		indices.append(top_inner)
		indices.append(next_top_inner)
		indices.append(next_bottom_inner)
	
	# Create the array mesh
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	
	# Create normals
	var normals = PackedVector3Array()
	normals.resize(vertices.size())
	for i in range(vertices.size()):
		normals[i] = Vector3(0, 1, 0)  # Default normal, will be recalculated
	arrays[Mesh.ARRAY_NORMAL] = normals
	
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	
	# Create a material for the outline
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 1.0, 1.0, 0.9)  # White, slightly transparent
	material.metallic = 0.5
	material.roughness = 0.3
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	arr_mesh.surface_set_material(0, material)
	
	return arr_mesh

func get_closest_outline(position: Vector3):
	var closest_outline = null
	var closest_distance = 9999.0
	
	for outline in outline_hexagons:
		var distance = position.distance_to(outline.position)
		if distance < closest_distance:
			closest_distance = distance
			closest_outline = outline
			
	return closest_outline

func remove_outline(outline):
	var index = outline_hexagons.find(outline)
	if index != -1:
		outline_hexagons.remove_at(index)
	outline.queue_free()

func generate_surrounding_outlines(center_position: Vector3, placed_tiles):
	# Hexagonal directions (60 degrees apart)
	var directions = [
		Vector3(HEX_SIZE * 1.5, 0, HEX_SIZE * 0.866),        # North East
		Vector3(0, 0, HEX_SIZE * 1.732),                     # North
		Vector3(-HEX_SIZE * 1.5, 0, HEX_SIZE * 0.866),       # North West
		Vector3(-HEX_SIZE * 1.5, 0, -HEX_SIZE * 0.866),      # South West
		Vector3(0, 0, -HEX_SIZE * 1.732),                    # South
		Vector3(HEX_SIZE * 1.5, 0, -HEX_SIZE * 0.866)        # South East
	]
	
	for dir in directions:
		var new_pos = center_position + dir
		
		# Check if there's already a tile or outline at this position
		var can_place = true
		for tile in placed_tiles:
			if tile.position.distance_to(new_pos) < 0.1:
				can_place = false
				break
				
		for outline in outline_hexagons:
			if outline.position.distance_to(new_pos) < 0.1:
				can_place = false
				break
				
		if can_place:
			add_outline_hexagon(new_pos)

func clear_all_outlines():
	for outline in outline_hexagons:
		outline.queue_free()
	outline_hexagons.clear()
	
	# Add the initial hexagon outline
	add_outline_hexagon(Vector3(0, 0, 0))
