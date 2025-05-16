extends Area2D

@export var start_zoom:float = 0
@export var end_zoom:float = 0
@onready var player:CharacterBody2D = null
@onready var camera = null
var global_start_x = null
var global_end_x = null

# Called when the node enters the scene tree for the first time.
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if player != null and camera != null:
		var player_x = player.global_position.x
		
		var t = clamp((player_x - global_start_x) / (global_end_x - global_start_x), 0, 1)

		camera.zoom.x = lerp(start_zoom, end_zoom, t)
		camera.zoom.y = lerp(start_zoom, end_zoom, t)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		camera = player.get_node("Camera2D")


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player = null
		camera = null
