class_name TileFactory
extends Node3D

# Terrain type constants
const TERRAIN_FLAT = "Flat"
const TERRAIN_HILLY = "Hilly"
const TERRAIN_MOUNTAINOUS = "Mountainous"
const TERRAIN_WATER = "Water"

# Constants for hexagon generation
const HEX_SIZE = 1.0

func create_terrain_tile(type: String) -> Node3D:
	var terrain: Node3D
	
	match type:
		TERRAIN_FLAT:
			# Create a flat hexagonal terrain
			terrain = create_flat_hex_terrain()
		TERRAIN_HILLY:
			# Create a hilly hexagonal terrain
			terrain = create_hilly_hex_terrain()
		TERRAIN_MOUNTAINOUS:
			# Create a mountainous hexagonal terrain
			terrain = create_mountainous_hex_terrain()
		TERRAIN_WATER:
			# Create a water hexagonal terrain
			terrain = create_water_hex_terrain()
		_:
			# Default to flat if unknown type
			terrain = create_flat_hex_terrain()
	
	return terrain
	
func create_flat_hex_terrain() -> Node3D:
	# For now, create a simple hexagon with a green material
	var mesh_instance = MeshInstance3D.new()
	
	# Create a simple hexagonal prism
	var hex_mesh = HexMesh.new()
	hex_mesh.divisions = 1
	
	# Create a material
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.2, 0.8, 0.2)  # Green for flat terrain
	
	mesh_instance.mesh = hex_mesh
	mesh_instance.material_override = material
	
	return mesh_instance
	
func create_hilly_hex_terrain() -> Node3D:
	# Similar to flat but with a different color and eventual height variation
	var mesh_instance = MeshInstance3D.new()
	
	var hex_mesh = HexMesh.new()
	hex_mesh.divisions = 1
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.5, 0.5, 0.2)  # Yellowish-brown for hills
	
	mesh_instance.mesh = hex_mesh
	mesh_instance.material_override = material
	
	return mesh_instance
	
func create_mountainous_hex_terrain() -> Node3D:
	# Similar to others but with gray color for mountains
	var mesh_instance = MeshInstance3D.new()
	
	var hex_mesh = HexMesh.new()
	hex_mesh.divisions = 1
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.5, 0.5, 0.5)  # Gray for mountains
	
	mesh_instance.mesh = hex_mesh
	mesh_instance.material_override = material
	
	return mesh_instance
	
func create_water_hex_terrain() -> Node3D:
	# Similar to others but with blue color for water
	var mesh_instance = MeshInstance3D.new()
	
	var hex_mesh = HexMesh.new()
	hex_mesh.divisions = 1
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.0, 0.3, 0.8)  # Blue for water
	material.metallic = 0.7
	material.roughness = 0.1
	
	mesh_instance.mesh = hex_mesh
	mesh_instance.material_override = material
	
	return mesh_instance
