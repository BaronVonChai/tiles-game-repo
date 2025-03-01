class_name NewGamePlayerOptions
extends HSlider

var team_options = ["Religious", "Socialists", "Old Regime", "International Peace Keepers"]
var controller_options = ["Human", "AI", "Online"]
var container: VBoxContainer
var delete_button : Button
var controller_slider : HSlider
var team_slider : HSlider
var contoller_label : Label
var team_value : Label
var player_label : Label


'func _init():
	min_value = 0
	max_value = len(team_options) - 1 # Adjust this since array is 0-based
	step = 1
	tick_count = len(team_options)
	ticks_on_borders = true
	theme_type_variation = "TeamSelectSlider" 
'
func create_player_container(player_number: int, parent_node: Node) -> void:
	# Ensure we don't reuse containers
	if container != null:
		return
		
	container = VBoxContainer.new()
	player_label = Label.new()
	player_label.text = "Player " + str(player_number)
	container.add_child(player_label)
	
	team_slider = HSlider.new()
	team_slider.min_value = 0
	team_slider.max_value = len(team_options) - 1
	team_slider.step = 1
	team_slider.tick_count = len(controller_options)
	team_slider.ticks_on_borders = true
	team_slider.theme_type_variation = "TeamSelectSlider"
	container.add_child(team_slider)
	
	team_value = Label.new()
	team_value.text = team_options[0]
	container.add_child(team_value)
	
	# Controller selection slider
	controller_slider = HSlider.new()
	controller_slider.min_value = 0
	controller_slider.max_value = len(controller_options) - 1
	controller_slider.step = 1
	controller_slider.tick_count = len(controller_options)
	controller_slider.ticks_on_borders = true
	controller_slider.theme_type_variation = "ControllerSelectSlider"
	container.add_child(controller_slider)
	
	contoller_label = Label.new()
	contoller_label.text = controller_options[0]
	container.add_child(contoller_label)
	
	delete_button = Button.new()
	delete_button.text = "Delete Player"
	delete_button.button_down.connect(_on_delete_pressed)
	delete_button.theme = load("res://Assets/Themes/RedButton.tres")
	container.add_child(delete_button)
	
	parent_node.add_child(container)
	
	controller_slider.value_changed.connect(_on_controller_value_changed)
	team_slider.value_changed.connect(_on_value_changed)

func _on_delete_pressed() -> void:
	var parent = container.get_parent()
	if parent.get_child_count() > 2:  # Minimum 2 players check
		container.queue_free()

func get_selected_slider_option(option: Array, list_value: int) -> String:
	return option[list_value]

func _ready():
	value_changed.connect(_on_value_changed)
	value_changed.connect(_on_controller_value_changed)
	

func _on_value_changed(new_value: float):
	team_value.text=team_options[int(new_value)]
	#print("Selected team: ", get_selected_slider_option(team_options, new_value))
	
func _on_controller_value_changed (new_value: float):
	contoller_label.text = controller_options[int(new_value)]
