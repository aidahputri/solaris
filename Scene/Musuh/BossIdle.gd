extends State
 
@onready var collision = $"../../Detection/CollisionShape2D"
 
var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)

func enter():
	super.enter()
	player_entered = false
	animation_player.play("idle")
		
func transition():
	if player_entered:
		get_parent().change_state("walk")
 
func _on_player_detection_body_entered(body):
	if body.name == "Player":
		player_entered = true
