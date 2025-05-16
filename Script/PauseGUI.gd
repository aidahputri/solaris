extends CanvasLayer

@onready var continue_button = $Panel/VBoxContainer/NinePatchRect/Continue
@onready var exit_button = $Panel/VBoxContainer/NinePatchRect/Exit

func _ready():
	visible = false
	get_tree().paused = false

func toggle_pause_menu():
	visible = !visible
	get_tree().paused = visible
	
	get_viewport().set_input_as_handled()

func _on_continue_pressed():
	print("continue pressed")
	toggle_pause_menu()

func _on_exit_pressed():
	print("continue pressed")
	get_tree().paused = false
	call_deferred("go_home")
	
func go_home():
	get_tree().change_scene_to_file("res://Scene/TitleScreen.tscn")
