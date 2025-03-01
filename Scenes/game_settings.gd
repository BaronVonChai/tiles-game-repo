extends Control

const NewGamePlayerOptions = preload("res://Scripts/NewGamePlayerOptions.gd") 

@onready var bottom_hbox = $BottomContainer/MarginContainer/HBoxContainer
@onready var add_player_button = $TopContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/AddPlayerButton as Button
@onready var tile_map_total_size = $TopContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/GameSize as LineEdit

func _ready() -> void:
	_on_add_player_button()
	_on_add_player_button()
	add_player_button.button_down.connect(_on_add_player_button)

func _process(delta: float) -> void:
	pass

func _on_add_player_button() -> void:
		var new_player = NewGamePlayerOptions.new()
		new_player.create_player_container(bottom_hbox.get_child_count() + 1, bottom_hbox)
