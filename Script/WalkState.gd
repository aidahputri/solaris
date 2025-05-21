extends State
 
func enter():
	super.enter()
	#owner.set_physics_process(true)
	owner.tempSpeed = 1
	animation_player.play("walk")

func exit():
	super.exit()
	owner.tempSpeed = 0
	#owner.set_physics_process(false)
 
func transition():
	var distance = owner.direction.length()
	if distance < owner.weaponPosition * 1.75:
		get_parent().change_state("attack")
	elif distance > $"../../Detection/CollisionShape2D".shape.radius:
		get_parent().change_state("idle")
