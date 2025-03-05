extends Node3D

# Reference to the camera
@onready var camera = $Camera3D

# Game Objects
var placed_tiles = []

# UI Elements
@onready var tiles_left_label = $Control/UI/TileTypePanel/MarginContainer/HBoxContainer/VBoxContainer2/TilesLeftContainer/TilesLeftLabel
@onready var undo_button = $Control/UI/TileTypePanel/MarginContainer/HBoxContainer/VBoxContainer2/UndoButton
@onready var reset_button = $Control/UI/TileTypePanel/MarginContainer/HBoxContainer/VBoxContainer2/ResetButton
@onready var generate_rest_button = $Control/UI/TileTypePanel/MarginContainer/HBoxContainer/VBoxContainer2/GenerateRestButton

# Tile type buttons
@onready var flat_button = $Control/UI/TileTypePanel/MarginContainer/HBoxContainer/VBoxContainer/FlatButton
@onready var hilly_button = $Control/UI/TileTypePanel/MarginContainer/HBoxContainer/VBoxContainer/HillyButton
@onready var mountain_button = $Control/UI/TileTypePanel/MarginContainer/HBoxContainer/VBoxContainer/MountainButton
@onready var water_button = $Control/UI/TileTypePanel/MarginContainer/HBoxContainer/VBoxContainer/WaterButton

# Game state
var total_tiles = 0
var placed_tiles_count = 0
var current_tile_type = TileFactory.TERRAIN_FLAT  # Default selected tile type

# Constants for hexagon generation
const HEX_SIZE = 1.0

# Managers
var tile_factory: TileFactory
var outline_manager: OutlineManager
var preview_manager: PreviewManager

func _ready():
	# Set up the directional light
	var light = DirectionalLight3D.new()
	light.position = Vector3(0, 10, 0)
	light.rotation_degrees = Vector3(-45, 45, 0)
	add_child(light)
	
	# Initialize the managers
	tile_factory = TileFactory.new()
	add_child(tile_factory)
	
	outline_manager = OutlineManager.new()
	add_child(outline_manager)
	
	preview_manager = PreviewManager.new(camera, tile_factory, outline_manager)
	add_child(preview_manager)
	preview_manager.tile_placed.connect(_on_tile_placed)
	
	# Connect button signals
	undo_button.pressed.connect(_on_undo_button_pressed)
	reset_button.pressed.connect(_on_reset_button_pressed)
	generate_rest_button.pressed.connect(_on_generate_rest_button_pressed)
	
	# Connect tile type button signals
	flat_button.pressed.connect(func(): select_tile_type(TileFactory.TERRAIN_FLAT))
	hilly_button.pressed.connect(func(): select_tile_type(TileFactory.TERRAIN_HILLY))
	mountain_button.pressed.connect(func(): select_tile_type(TileFactory.TERRAIN_MOUNTAINOUS))
	water_button.pressed.connect(func(): select_tile_type(TileFactory.TERRAIN_WATER))
	
	# Set initial game state
	set_total_tiles(20)  # Default to 20 tiles, this would come from GameSettings later
	update_tiles_left_display()
	
	# Set initial button highlight
	select_tile_type(TileFactory.TERRAIN_FLAT)
	
# Game State Management Functions
func set_total_tiles(amount: int):
	total_tiles = amount
	placed_tiles_count = 0
	update_tiles_left_display()

func update_tiles_left_display():
	if tiles_left_label:
		tiles_left_label.text = str(placed_tiles_count) + " / " + str(total_tiles)

# Button Signal Handlers
func _on_undo_button_pressed():
	if placed_tiles_count > 0 and placed_tiles.size() > 0:
		placed_tiles_count -= 1
		update_tiles_left_display()
		
		# Remove the last placed tile
		var last_tile = placed_tiles.pop_back()
		var last_position = last_tile.position
		
		# First remove all outlines that might conflict with our new ones
		for outline in outline_manager.outline_hexagons.duplicate():
			if outline.position.distance_to(last_position) < HEX_SIZE * 2.5:
				outline_manager.remove_outline(outline)
		
		# Create a new outline hexagon where the tile was
		outline_manager.add_outline_hexagon(last_position)
		
		# If there are still tiles on the board, regenerate outlines around them
		# to ensure grid integrity
		if placed_tiles.size() > 0:
			for tile in placed_tiles:
				outline_manager.generate_surrounding_outlines(tile.position, placed_tiles)
		
		last_tile.queue_free()
		
		print("Undoing last tile placement")

func _on_reset_button_pressed():
	placed_tiles_count = 0
	update_tiles_left_display()
	
	# Remove all tiles
	for tile in placed_tiles:
		tile.queue_free()
	placed_tiles.clear()
	
	# Clear all outlines and reset to initial state
	outline_manager.clear_all_outlines()
	
	# Reset the preview tile
	preview_manager.create_preview_tile(current_tile_type)
	
	print("Resetting the board")

func _on_generate_rest_button_pressed():
	print("Generating the rest of the tiles")
	# Here you would add code to automatically place remaining tiles
	
# Tile Type Selection
func select_tile_type(type: String):
	current_tile_type = type
	
	# Reset all button colors
	flat_button.modulate = Color(1, 1, 1)
	hilly_button.modulate = Color(1, 1, 1)
	mountain_button.modulate = Color(1, 1, 1)
	water_button.modulate = Color(1, 1, 1)
	
	# Highlight the selected button
	match type:
		TileFactory.TERRAIN_FLAT:
			flat_button.modulate = Color(0.5, 1, 0.5)  # Light green highlight
		TileFactory.TERRAIN_HILLY:
			hilly_button.modulate = Color(0.5, 1, 0.5)
		TileFactory.TERRAIN_MOUNTAINOUS:
			mountain_button.modulate = Color(0.5, 1, 0.5)
		TileFactory.TERRAIN_WATER:
			water_button.modulate = Color(0.5, 1, 0.5)
	
	print("Selected tile type: " + current_tile_type)
	
	# Create or update preview tile
	preview_manager.create_preview_tile(current_tile_type)
	
func _on_tile_placed(position, tile_type):
	if placed_tiles_count < total_tiles:
		# Create a permanent tile at this location
		var permanent_tile = tile_factory.create_terrain_tile(tile_type)
		permanent_tile.position = position
		add_child(permanent_tile)
		placed_tiles.append(permanent_tile)
		
		# Remove this outline hexagon
		var outline_to_remove = null
		for outline in outline_manager.outline_hexagons:
			if outline.position.distance_to(position) < 0.1:
				outline_to_remove = outline
				break
				
		if outline_to_remove:
			outline_manager.remove_outline(outline_to_remove)
		
		# Create new outline hexagons around this tile
		outline_manager.generate_surrounding_outlines(permanent_tile.position, placed_tiles)
		
		# Update placed tiles counter
		placed_tiles_count += 1
		update_tiles_left_display()
