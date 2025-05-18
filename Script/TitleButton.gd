extends TextureButton

func _on_pressed():
	call_deferred("start_scene")

func start_scene():
	get_tree().change_scene_to_file(str("res://Scene/Prologue.tscn"))
	#get_tree().change_scene_to_file(str("res://Scene/Level1/Level1.tscn"))
	#get_tree().change_scene_to_file(str("res://Scene/Level3/Level3.tscn"))

func _on_exit_pressed():
	call_deferred("exit_game")
	
func exit_game():
	get_tree().quit()
