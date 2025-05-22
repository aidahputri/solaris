extends Control

@onready var fadeRect = $FadeCanvas.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fadeRect.modulate.a = 1.0
	Global.playerHealth = 100
	await fade_in()

func fade_in():
	var tween = create_tween()
	tween.tween_property(fadeRect, "modulate:a", 0.0, 1.0)
	await tween.finished
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
