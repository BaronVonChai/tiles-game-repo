class_name PreviewManager
extends Node3D

signal tile_placed(position, tile_type)

# References to needed objects
var camera: Camera3D
var tile_factory: TileFactory
var outline_manager: OutlineManager

# Preview state
var preview_tile: Node3D = null
var current_tile_type: String = ""

# Constants
const HEX_SIZE = 1.0

func _init(p_camera: Camera3D, p_tile_factory: TileFactory, p_outline_manager: OutlineManager):
	camera = p_camera
	tile_factory = p_tile_factory
	outline_manager = p_outline_manager

func _process(_delta):
	update_preview_position()
	check_for_tile_placement()

func update_preview_position():
	if preview_tile:
		var mouse_pos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * 100
		
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = space_state.intersect_ray(query)
		
		if result:
			preview_tile.position = result.position
			
			# Find the closest outline hexagon to the mouse position
			var closest_outline = outline_manager.get_closest_outline(result.position)
			if closest_outline and closest_outline.position.distance_to(result.position) < HEX_SIZE * 0.5:
				preview_tile.position = closest_outline.position
				outline_manager.current_outline_hexagon = closest_outline
			else:
				outline_manager.current_outline_hexagon = null

func check_for_tile_placement():
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if preview_tile and outline_manager.current_outline_hexagon:
			place_preview_tile()

func create_preview_tile(tile_type: String):
	# Update the current tile type
	current_tile_type = tile_type
	
	# Remove existing preview tile if any
	if preview_tile:
		preview_tile.queue_free()
		preview_tile = null
		
	# Create a new preview tile based on selected type
	preview_tile = tile_factory.create_terrain_tile(current_tile_type)
	preview_tile.position = Vector3(0, 0.1, 0)  # Start slightly above ground
	add_child(preview_tile)

func place_preview_tile():
	if preview_tile and outline_manager.current_outline_hexagon:
		# Check that we're close enough to the outline hexagon
		var distance = preview_tile.position.distance_to(outline_manager.current_outline_hexagon.position)
		if distance < HEX_SIZE * 0.5:
			# Tell the parent that a tile was placed
			emit_signal("tile_placed", outline_manager.current_outline_hexagon.position, current_tile_type)
			
			# Create a new preview tile
			create_preview_tile(current_tile_type)
