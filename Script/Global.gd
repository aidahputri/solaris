extends Node

@export var playerHealth = 100
@export var playerJump = 2
var curLevel = "0"
var is_dialog_active: bool = false
var dialog_seen = {}

func _process(delta: float) -> void:
	print(curLevel)
