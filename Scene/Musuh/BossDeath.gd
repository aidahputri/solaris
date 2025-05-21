extends State
 
func enter():
	super.enter()
	$"../../WeaponHitbox/CollisionShape2D".disabled = true
	animation_player.play("death")
	await animation_player.animation_finished
	owner.queue_free()
