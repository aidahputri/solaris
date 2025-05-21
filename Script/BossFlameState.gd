extends State
 
func enter():
	super.enter()
	await get_tree().create_timer(owner.timeBeforeAttack).timeout
	animation_player.play("flame")
	$"../../FlameHitbox/CollisionShape2D".disabled = false
	await animation_player.animation_finished
	$"../../FlameHitbox/CollisionShape2D".disabled = true
 
func transition():
	if not animation_player.is_playing():
		get_parent().change_state("walk")
