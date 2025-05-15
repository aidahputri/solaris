extends Node

@onready var healthBar = $GUI.get_child(0)
@onready var jumpBar = $GUI.get_child(1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthBar.value = Global.playerHealth
	jumpBar.value = Global.playerJump
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
