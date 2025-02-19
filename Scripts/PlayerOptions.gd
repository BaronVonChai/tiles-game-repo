class_name PlayerOptions
extends HSlider

var team_options = ["One", "Two", "Three", "four"]
var container: VBoxContainer
var player_label: Label

func _init():
	min_value = 0
	max_value = len(team_options) - 1 # Adjust this since array is 0-based
	step = 1
	tick_count = len(team_options)
	ticks_on_borders = true
	theme_type_variation = "TeamSelectSlider" 

func create_player_container(player_number: int, parent_node: Node) -> void:
	container = VBoxContainer.new()
	
	player_label = Label.new()
	player_label.text = "Player " + str(player_number)
	container.add_child(player_label)
	
	container.add_child(self)
	parent_node.add_child(container)

func get_selected_team() -> String:
	return team_options[value]

func _ready():
	value_changed.connect(_on_value_changed)

func _on_value_changed(new_value: float):
	print("Selected team: ", get_selected_team())
