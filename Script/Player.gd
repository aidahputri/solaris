extends CharacterBody2D

@export var SPEED := 400
@export var JUMP_SPEED := -400
@export var GRAVITY := 1200
@onready var animplayer = $AnimatedSprite2D
@export var attack_damage := 10
@export var knockback_force := 10
@export var healthComponent: HealthComponent
@export var total_jump = 2
@onready var dust_particle = $DustParticle
@onready var drop_particle = preload("res://Scene/DropParticle.tscn")
@onready var attack_sfx_player = $AttackSfxPlayer
@onready var run_sfx_player = $RunSfxPlayer
@onready var landing_sfx_player = $LandingSfxPlayer
@export var sfx:String = ""

const UP = Vector2(0,-1)
var is_attacking = false
var jumps = total_jump

var attack_cooldown := 1.0 
var time_since_attack := 0.0
var is_grounded = true

var direction = 0

func _ready():
	Global.playerJump = jumps
	
func _physics_process(delta: float) -> void:
	if Global.is_dialog_active:
		velocity = Vector2.ZERO
		animplayer.play("idle")
		return
		
	time_since_attack += delta
	velocity.y += delta*GRAVITY
	drop_dust_animation()
	is_grounded = is_on_floor()
	move()
	jump()
	attack()
	move_and_slide()
	animations()
	
	if time_since_attack >= attack_cooldown:
		perform_attack()
		time_since_attack = 0.0
	
func move():
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0:
			$WeaponHitbox.position.x = -37.5
			animplayer.flip_h = true
		else:
			animplayer.flip_h = false
			$WeaponHitbox.position.x = 37.5
		if is_on_floor():
			dust_particle.set_emitting(true)
		else:
			dust_particle.set_emitting(false)
		if $RunTimer.is_stopped():
			$RunTimer.start(0.3)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		dust_particle.set_emitting(false)
		
func jump():
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor() or jumps > 0:
			velocity.y = JUMP_SPEED
			jumps-=1
			Global.playerJump = jumps

func attack():
	if Input.is_action_just_pressed("attack") and is_on_floor():
		is_attacking = true
		animplayer.play("attack")
		$WeaponHitbox/CollisionShape2D.disabled = false
		await animplayer.animation_finished
		attack_sfx_player.play()
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
		Global.playerJump = jumps
		if velocity.x == 0:
			animplayer.play("idle")
		else:
			animplayer.play("run")

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

func drop_dust_animation():
	if is_grounded == false and is_on_floor() == true:
		var instance = drop_particle.instantiate()
		instance.global_position = $Marker2D.global_position
		get_parent().add_child(instance)
		play_landing_sfx()

func play_attack_sfx():
	var random_pitch = randf_range(0.9,1.1)
	attack_sfx_player.pitch_scale = random_pitch
	attack_sfx_player.play()

func play_run_sfx():
	var random_pitch = randf_range(0.8,1.2)
	run_sfx_player.pitch_scale = random_pitch
	run_sfx_player.play()

func play_landing_sfx():
	var random_pitch = randf_range(0.8,1.2)
	landing_sfx_player.pitch_scale = random_pitch
	landing_sfx_player.play()
	
func _on_run_timer_timeout() -> void:
	if is_on_floor() and direction != 0:
		play_run_sfx()
	else:
		$RunTimer.stop()
