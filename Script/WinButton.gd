extends TextureButton

@onready var fadeRect = get_parent().get_node("FadeCanvas").get_child(0)
var nextScene = ""

func fade_out():
	var tween = create_tween()
	tween.tween_property(fadeRect, "modulate:a", 1.0, 1.0)
	await tween.finished
	call_deferred("change_scene")

func change_scene():
	if Global.playerHealth <= 0:
		nextScene = "res://Scene/DeathScene.tscn"
	get_tree().change_scene_to_file(nextScene)
	
func _on_pressed() -> void:
	nextScene = "res://Scene/TitleScreen.tscn"
	await fade_out()
