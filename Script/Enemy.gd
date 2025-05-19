extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var sprite = $AnimatedSprite2D

@export_group("Sprite Configuration")
@export var spriteFrame: SpriteFrames
@export var xSpriteFrame: int = 0
@export var ySpriteFrame: int = 0

@export_group("Movement")
@export var speed: int = 40
var gravity: int = 980
var tempSpeed: int = 0
var direction: Vector2

@export_group("Combat")
@export var health: int = 50
@export var attack_damage: int = 10
@export var knockback_force: int = 10
@export var weaponPosition: int = 35
@export var timeBeforeAttack: float = 0.5

func _ready() -> void:
	$HealthComponent.health = health
	sprite.sprite_frames = spriteFrame
	sprite.position.x = xSpriteFrame
	sprite.position.y = ySpriteFrame
	
func _process(_delta):
	if $HealthComponent.health <= 0:
		find_child("FiniteStateMachine").change_state("death")
	direction = player.position - position
	velocity.y += gravity * _delta
	
	if direction.x < 0:
		$WeaponHitbox.position.x = weaponPosition * -1
		sprite.flip_h = true
	else:
		$WeaponHitbox.position.x = weaponPosition
		sprite.flip_h = false

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if direction.length() > 0:
		velocity.x = direction.normalized().x * (speed * tempSpeed)
	else:
		velocity.x = 0
	
	move_and_slide()

func _on_weapon_hitbox_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox: HitboxComponent = area
		
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		
		hitbox.damage(attack)
