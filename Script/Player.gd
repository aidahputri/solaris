extends CharacterBody2D

@export var SPEED := 200
@export var JUMP_SPEED := -400
@export var GRAVITY := 1200
@onready var animplayer = $AnimatedSprite2D

const UP = Vector2(0,-1)
var is_attacking = false

func _physics_process(delta: float) -> void:
	velocity.y += delta*GRAVITY
	move()
	jump()
	attack()
	move_and_slide()
	animations()
	
func move():	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0:
			$Area2D.position.x = -37.5
			animplayer.flip_h = true
		else:
			animplayer.flip_h = false
			$Area2D.position.x = 37.5
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func jump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_SPEED

func attack():
	if Input.is_action_just_pressed("attack") and is_on_floor():
		is_attacking = true
		animplayer.play("attack")
		$Area2D/CollisionShape2D.disabled = false
		await animplayer.animation_finished
		$Area2D/CollisionShape2D.disabled = true
		is_attacking = false

func animations():
	if is_attacking:
		return

	if !is_on_floor():
		if velocity.y < 0:
			animplayer.play("jump")
		else:
			animplayer.play("fall")
	else:
		if velocity.x == 0:
			animplayer.play("idle")
		else:
			animplayer.play("walk")
