extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var sprite = $AnimatedSprite2D

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
@export var timeBeforeAttack: float = 0.5
@export var radius: int = 200
var weaponPosition: int = 81.25

var hitbox = null
var attack = null
var immune = false

func _ready() -> void:
	$ProgressBar.max_value = health
	$ProgressBar.value = health
	$ProgressBar.position.y = $CollisionShape2D.position.y * 2.5 - 5
	
	$HealthComponent.health = health
	if flipped:
		sprite.flip_h = true
	$Detection/CollisionShape2D.shape.radius = radius

func _process(_delta):
	$ProgressBar.value = $HealthComponent.health
	if $HealthComponent.health <= 0:
		$ProgressBar.visible = false
		find_child("FiniteStateMachine").change_state("death")
	direction = player.position - position
	velocity.y += gravity * _delta
	if direction.x < 0:
		$WeaponHitbox.position.x = weaponPosition * -1
		sprite.flip_h = false
	else:
		$WeaponHitbox.position.x = weaponPosition
		sprite.flip_h = true

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if direction.length() > 0 && is_on_floor():
		velocity.x = direction.normalized().x * (speed * tempSpeed)

	move_and_slide()

func _on_weapon_hitbox_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		hitbox = area
		
		attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		
		if direction.x < 0:
			attack.attack_dir = -1
		else:
			attack.attack_dir = 1
		
		if $AttackTimer.is_stopped() and ($AnimatedSprite2D.animation == "attack"):
			$AttackTimer.start(timeBeforeAttack)


func _on_attack_timer_timeout() -> void:
	if hitbox != null and attack != null:
		var player = hitbox.get_parent()
		player.hurt()
		hitbox.damage(attack)
	$AttackTimer.stop()

func _on_weapon_hitbox_area_exited(area: Area2D) -> void:
	hitbox = null
	attack = null

func hurt():
	$ImmuneTimer.start(0.5)
	immune = true
	if $AnimatedSprite2D.sprite_frames.has_animation("hurt"):
		$AnimatedSprite2D.play("hurt")
		await $AnimatedSprite2D.animation_finished

func _on_immune_timer_timeout() -> void:
	immune = false
	$ImmuneTimer.stop()
