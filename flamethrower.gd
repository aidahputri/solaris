extends Area2D

@export var attack_damage: int = 10
var hitbox = null
var attack = null
var immune = false

func _on_weapon_hitbox_area_entered(area: Area2D) -> void:
	if area is HitboxComponent and area.get_parent().name == "Player":
		hitbox = area
		
		attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.attack_position = global_position
		
		if $AttackTimer.is_stopped() and ($AnimatedSprite2D.animation == "attack"):
			$AttackTimer.start()

func _on_attack_timer_timeout() -> void:
	if hitbox != null and attack != null:
		var player = hitbox.get_parent()
		player.hurt()
		hitbox.damage(attack)
	$AttackTimer.stop()
	
func _on_weapon_hitbox_area_exited(area: Area2D) -> void:
	hitbox = null
	attack = null
	
func _on_immune_timer_timeout() -> void:
	immune = false
	$ImmuneTimer.stop()
