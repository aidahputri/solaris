extends Node2D
class_name HealthComponent

@export var MAX_HEALTH: float = 100.0
var health: float
@export var progressBar: ProgressBar
var knockback: bool

func _ready() -> void:
	health = MAX_HEALTH
	#Global.playerHealth = health

func damage(attack: Attack):
	health -= attack.attack_damage
	if attack.attack_dir != 0:
		var knockback_vector = Vector2(
			100 * attack.attack_dir,  # X direction
			-50
			)

		# Apply the knockback
		owner.velocity = knockback_vector
		owner.move_and_slide()

	#owner.velocity.y = -500
	#owner.velocity.x = 500 * attack.attack_dir
	
	#Global.playerHealth = health
	
	#if health <= 0:
		#get_parent().queue_free()
