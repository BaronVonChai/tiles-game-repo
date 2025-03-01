extends Node3D

var tiles_value = 1

func _ready():
	
	var light = DirectionalLight3D.new()
	light.position = Vector3(0, 10, 0)
	light.rotation_degrees = Vector3(-45, 45, 0)
	add_child(light)
	
	# Create and setup the hex grid
	var hex_grid = HexagonalRidgeHexGrid.new()
	hex_grid.set_size(tiles_value)
	
	# Set up noise for terrain generation
	var biomes_noise = FastNoiseLite.new()
	var hex_noise = FastNoiseLite.new()
	var ridge_noise = FastNoiseLite.new()
	
	hex_grid.set_biomes_noise(biomes_noise)
	hex_grid.set_hex_noise(hex_noise)
	hex_grid.set_ridge_noise(ridge_noise)
	
	# Set default values for ridge parameters
	hex_grid.set_ridge_variation_min_bound(0.0)
	hex_grid.set_ridge_variation_max_bound(1.0)
	hex_grid.set_ridge_top_offset(1.0)
	hex_grid.set_ridge_bottom_offset(0.0)
	
	# Set biome parameters
	hex_grid.set_biomes_hill_level_ratio(0.5)
	hex_grid.set_biomes_plain_hill_gain(1.0)
	
	# Enable smooth normals for better appearance
	hex_grid.set_smooth_normals(true)
	
	add_child(hex_grid)
	
