extends Node

@onready var healthBar = $GUI.get_child(0)
@onready var jumpBar = $GUI.get_child(1)
@onready var pauseMenu = $PauseGUI
@onready var fadeRect = $FadeCanvas.get_child(0)
@export var nextScene = ""

func _ready() -> void:
	healthBar.max_value = 100
	jumpBar.max_value = 2
	healthBar.value = Global.playerHealth
	jumpBar.value = Global.playerJump
	Global.curLevel = name
	fadeRect.modulate.a = 1.0
	await fade_in()

func _process(delta: float) -> void:
	healthBar.value = Global.playerHealth
	jumpBar.value = Global.playerJump
	if Global.playerHealth <= 0:
		await fade_out()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause"):
		pauseMenu.toggle_pause_menu()
		
func fade_in():
	var tween = create_tween()
	tween.tween_property(fadeRect, "modulate:a", 0.0, 1.0)
	await tween.finished
		
func fade_out():
	var tween = create_tween()
	tween.tween_property(fadeRect, "modulate:a", 1.0, 1.0)
	await tween.finished
	call_deferred("change_scene")
	
func change_scene():
	if Global.playerHealth <= 0:
		nextScene = "res://Scene/DeathScene.tscn"
	get_tree().change_scene_to_file(nextScene)

func _on_finish_area_body_entered(body: Node2D):
	if body.name == "Player":
		fade_out()

func boss_died():
	nextScene = ""
	fade_out()
