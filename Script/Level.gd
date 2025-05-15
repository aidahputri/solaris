extends Node

@onready var healthBar = $GUI.get_child(0)
@onready var jumpBar = $GUI.get_child(1)

func _ready() -> void:
	healthBar.max_value = 100
	jumpBar.max_value = 2
	healthBar.value = Global.playerHealth
	jumpBar.value = Global.playerJump

func _process(delta: float) -> void:
	healthBar.value = Global.playerHealth
	jumpBar.value = Global.playerJump
