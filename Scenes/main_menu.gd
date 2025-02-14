class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button



func _ready():
	start_button.button_down.connect(on_start_button_down)
	options_button.button_down.connect(on_options_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	
func on_start_button_down() -> void:
	print("new game started")
	get_tree().change_scene_to_file("res://Scenes/Game_Settings.tscn")
	
	
func on_options_pressed() -> void:
	print("options button pressed")
	pass
	
func on_exit_pressed() -> void:
	get_tree().quit()
	
