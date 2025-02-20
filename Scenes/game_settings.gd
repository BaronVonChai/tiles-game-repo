extends Control

const PlayerOptions = preload("res://Scripts/PlayerOptions.gd") 

@onready var bottom_hbox = $BottomContainer/MarginContainer/HBoxContainer
@onready var add_player_button = $TopContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/AddPlayerButton as Button

func _ready() -> void:
	add_player_button.button_down.connect(_on_add_player_button)

func _process(delta: float) -> void:
	pass

# In your GameSettings script
func _on_add_player_button() -> void:
	if bottom_hbox.get_child_count() == 0:
		# Add initial two players if none exist
		var player1 = PlayerOptions.new()
		var player2 = PlayerOptions.new()
		player1.create_player_container(1, bottom_hbox)
		player2.create_player_container(2, bottom_hbox)
	else:
		var new_player = PlayerOptions.new()
		new_player.create_player_container(bottom_hbox.get_child_count() + 1, bottom_hbox)
