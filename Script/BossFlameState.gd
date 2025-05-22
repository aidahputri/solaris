extends State
 
func enter():
	super.enter()
	await get_tree().create_timer(owner.timeBeforeAttack).timeout
	var parent = get_parent().get_parent()
	parent.play_flame_sfx()
	animation_player.play("flame")
	$"../../FlameHitbox/CollisionShape2D".disabled = false
	await animation_player.animation_finished
	$"../../FlameHitbox/CollisionShape2D".disabled = true
 
func transition():
	if not animation_player.is_playing():
		get_parent().change_state("walk")
