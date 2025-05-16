extends Node2D
class_name HealthComponent

@export var MAX_HEALTH: float = 100.0
var health: float
@export var progressBar: ProgressBar

func _ready() -> void:
	health = MAX_HEALTH
	Global.playerHealth = health

	
func damage(attack: Attack):
	health -= attack.attack_damage
		
	Global.playerHealth = health
	
	#if health <= 0:
		#get_parent().queue_free()
