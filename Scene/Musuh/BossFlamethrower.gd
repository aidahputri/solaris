extends State

@export var flamethrower: PackedScene
var can_transition: bool = false
 
func enter():
	super.enter()
	await get_tree().create_timer(1).timeout
	#animation_player.play("ranged_attack")
	#await animation_player.animation_finished
	shoot()
	can_transition = true
 
func shoot():
	var flame = flamethrower.instantiate()
	flame.position = $"../../WeaponHitbox".global_position
	get_tree().current_scene.add_child(flame)
	flame.get_child(0).play("attack")
	await flame.get_child(0).animation_finished
	flame.queue_free()

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("walk")
