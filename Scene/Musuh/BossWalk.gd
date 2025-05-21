extends State
 
func enter():
	super.enter()
	#owner.set_physics_process(true)
	owner.tempSpeed = 1
	var enemy = get_parent().get_parent()
	if enemy.speed != 0:
		animation_player.play("walk")

func exit():
	super.exit()
	owner.tempSpeed = 0
	#owner.set_physics_process(false)
 
func transition():
	var distance = owner.direction.length()
	if distance < owner.weaponPosition * 1.5:
		get_parent().change_state("attack")
	#if distance > owner.weaponPosition * 1.75:
		#get_parent().change_state("flamethrower")
	#elif distance > $"../../Detection/CollisionShape2D".shape.radius + 100:
		#get_parent().change_state("idle")
