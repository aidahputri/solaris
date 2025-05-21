extends State
 
func enter():
	var parent = get_parent().get_parent()
	super.enter()
	$"../../WeaponHitbox/CollisionShape2D".disabled = true
	animation_player.play("death")
	parent.play_death_sfx()
	await animation_player.animation_finished
	owner.queue_free()
