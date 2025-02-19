extends Control

const PlayerOptions = preload("res://Scripts/PlayerOptions.gd") 

@onready var bottom_hbox = $BottomContainer/MarginContainer/HBoxContainer
@onready var add_player_button = $TopContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/AddPlayerButton as Button

func _ready() -> void:
	add_player_button.button_down.connect(_on_add_player_button)

func _process(delta: float) -> void:
	pass

func _on_add_player_button() -> void:
	var new_player = PlayerOptions.new()
	new_player.create_player_container(bottom_hbox.get_child_count() + 1, bottom_hbox)
