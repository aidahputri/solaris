extends CharacterBody2D

@export var SPEED := 200
@export var JUMP_SPEED := -400
@export var GRAVITY := 1200
@onready var animplayer = $AnimatedSprite2D
@export var attack_damage := 10
@export var knockback_force := 10
@export var healthComponent: HealthComponent

const UP = Vector2(0,-1)
var is_attacking = false
@export var total_jump = 1
var jumps = total_jump

var attack_cooldown := 1.0 
var time_since_attack := 0.0

func _physics_process(delta: float) -> void:
	time_since_attack += delta
	velocity.y += delta*GRAVITY
	move()
	jump()
	attack()
	move_and_slide()
	animations()
	
	if time_since_attack >= attack_cooldown:
		perform_attack()
		time_since_attack = 0.0
	
func move():
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0:
			$WeaponHitbox.position.x = -37.5
			animplayer.flip_h = true
		else:
			animplayer.flip_h = false
			$WeaponHitbox.position.x = 37.5
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func jump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_SPEED
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor() and jumps > 0:
		velocity.y = JUMP_SPEED
		jumps = jumps - 1

func attack():
	if Input.is_action_just_pressed("attack") and is_on_floor():
		is_attacking = true
		animplayer.play("attack")
		$WeaponHitbox/CollisionShape2D.disabled = false
		await animplayer.animation_finished
		$WeaponHitbox/CollisionShape2D.disabled = true
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
		jumps = total_jump
		if velocity.x == 0:
			animplayer.play("idle")
		else:
			animplayer.play("walk")


func _on_weapon_hitbox_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox: HitboxComponent = area
		
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		
		hitbox.damage(attack)
		
		attack = Attack.new()
		attack.attack_damage = -10
		healthComponent.damage(attack)

func perform_attack() -> void:
	var attack = Attack.new()
	attack.attack_damage = 5
	healthComponent.damage(attack)
