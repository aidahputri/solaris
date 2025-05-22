extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var sprite = $AnimatedSprite2D
@onready var attack_sfx_player = $AttackSfxPlayer
@onready var hurt_sfx_player = $HurtSfxPlayer
@onready var death_sfx_player = $DeathSfxPlayer

@export_group("Sprite Configuration")
@export var spriteFrame: SpriteFrames
@export var xSpriteFrame: int = 0
@export var ySpriteFrame: int = 0

@export_group("Movement")
@export var speed: int = 40
@export var flipped = false

var gravity: int = 980
var tempSpeed: int = 0
var direction: Vector2

@export_group("Combat")
@export var health: int = 50
@export var attack_damage: int = 10
@export var knockback_force: int = 10
@export var weaponPosition: int = 35
@export var bodyOffset: int = 35
@export var timeBeforeAttack: float = 0.5
@export var maxDistance = 30

@export_group("Sfx")
@export var attackSfx = ""
@export var hurtSfx = ""
@export var deathSfx = ""

var hitbox = null
var attack = null
var immune = false

func _ready() -> void:
	$ProgressBar.max_value = health
	$ProgressBar.value = health
	$ProgressBar.position.y = $CollisionShape2D.position.y * 2.5 - 5
	
	initiate_sfx()
	
	$HealthComponent.health = health
	
	sprite.sprite_frames = spriteFrame
	sprite.position.x = xSpriteFrame
	sprite.position.y = ySpriteFrame
	if flipped:
		sprite.flip_h = true
	#$Detection/CollisionShape2D.shape.radius = 200

func _process(_delta):
	$ProgressBar.value = $HealthComponent.health
	if $HealthComponent.health <= 0:
		$ProgressBar.visible = false
		find_child("FiniteStateMachine").change_state("death")
	direction = player.position - position
	velocity.y += gravity * _delta
	if direction.x < 0:
		$WeaponHitbox.position.x = bodyOffset * -1
		sprite.flip_h = true
	else:
		$WeaponHitbox.position.x = bodyOffset
		sprite.flip_h = false

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if direction.length() > 0 && is_on_floor():
		velocity.x = direction.normalized().x * (speed * tempSpeed)
	#if direction.length() > 0:
		#velocity.x = direction.normalized().x * (speed * tempSpeed)
	#else:
		#velocity.x = 0

	move_and_slide()

func _on_weapon_hitbox_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		#$WeaponHitbox/CollisionShape2D.disabled = true
		if area.get_parent().name == "Player":
			hitbox = area
			attack = Attack.new()
			attack.attack_damage = attack_damage
			attack.knockback_force = knockback_force
			attack.attack_position = global_position
			
			if direction.x < 0:
				attack.attack_dir = -1
			else:
				attack.attack_dir = 1
			play_attack_sfx()
			if $AttackTimer.is_stopped() and ($AnimatedSprite2D.animation == "attack"):
				$AttackTimer.start(timeBeforeAttack)
		
func play_attack_sfx():
	var random_pitch = randf_range(0.9,1.1)
	attack_sfx_player.pitch_scale = random_pitch
	attack_sfx_player.play()
	
func play_hurt_sfx():
	var random_pitch = randf_range(0.8,1.2)
	hurt_sfx_player.pitch_scale = random_pitch
	hurt_sfx_player.play()

func play_death_sfx():
	var random_pitch = randf_range(0.8,1.2)
	death_sfx_player.pitch_scale = random_pitch
	death_sfx_player.play()

func _on_attack_timer_timeout() -> void:
	if hitbox != null and attack != null:
		var player = hitbox.get_parent()
		if player.name == "Player":
			var area_center_x = $WeaponHitbox/CollisionShape2D.global_position.x
			var player_x = player.global_position.x
			var x_distance = abs(player_x - area_center_x)
			print(x_distance)
			if x_distance < maxDistance :
				player.hurt()
				hitbox.damage(attack)
	$AttackTimer.stop()

func _on_weapon_hitbox_area_exited(area: Area2D) -> void:
	if hitbox != null and attack != null and !$AttackTimer.is_stopped():
		var player = hitbox.get_parent()
		if player.name == "Player":
			var area_center_x = $WeaponHitbox/CollisionShape2D.global_position.x
			var player_x = player.global_position.x
			var x_distance = abs(player_x - area_center_x)
			print(x_distance)
			if x_distance < maxDistance :
				player.hurt()
				hitbox.damage(attack)

func hurt():
	play_hurt_sfx()
	$ImmuneTimer.start(0.5)
	immune = true
	$AnimatedSprite2D.play("hurt")
	await $AnimatedSprite2D.animation_finished

func _on_immune_timer_timeout() -> void:
	immune = false
	$ImmuneTimer.stop()

func initiate_sfx():
	if attackSfx != "":
		attack_sfx_player.stream = load(attackSfx)
	if deathSfx != "":
		death_sfx_player.stream = load(hurtSfx)
	if hurtSfx != "":
		hurt_sfx_player.stream = load(hurtSfx)
