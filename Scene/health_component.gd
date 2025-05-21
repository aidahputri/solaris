extends Node2D
class_name HealthComponent

@export var MAX_HEALTH: float = 100.0
var health: float
@export var progressBar: ProgressBar
var knockback: bool

func _ready() -> void:
	health = MAX_HEALTH
	var object = get_parent()
	if object.name == "Player":
		Global.playerHealth = health

func damage(attack: Attack):
	health -= attack.attack_damage
	var object = get_parent()
	
	if health > MAX_HEALTH:
		health = MAX_HEALTH
		
	if attack.attack_dir != 0:
		var knockback_vector = Vector2(
			50 * attack.attack_dir, 
			-50
			)

		owner.velocity = knockback_vector
		owner.move_and_slide()
	
	if object.name == "Player":
		Global.playerHealth = health
