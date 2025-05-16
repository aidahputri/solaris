extends Area2D

@onready var global_start_x = null
@onready var global_end_x = null
@onready var player:CharacterBody2D = null
@onready var camera = null
@export var start_y = 0
@export var end_y = 100

func _ready() -> void:
	var collision_shape = $CollisionShape2D
	var shape = collision_shape.shape
	var extents = shape.extents
	var top_left = Vector2(-extents.x, -extents.y)
	var bottom_right = Vector2(extents.x, extents.y)

	var global_top_left = collision_shape.to_global(top_left)
	var global_bottom_right = collision_shape.to_global(bottom_right)
	
	global_start_x = global_top_left.x
	global_end_x = global_bottom_right.x
	
func _process(delta: float) -> void:
	if player != null:
		var player_x = player.global_position.x
		camera = player.get_node("Camera2D")
		
		var t = clamp((player_x - global_start_x) / (global_end_x - global_start_x), 0, 1)
		camera.offset.y = lerp(start_y, end_y, t)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player = null
