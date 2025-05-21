extends Area2D

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		call_deferred("change_to_death_scene")

func change_to_death_scene():
	get_tree().change_scene_to_file("res://Scene/DeathScene.tscn")
