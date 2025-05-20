class_name PlayerCamera extends Camera2D

func _ready() -> void:
	print("Camera Ready")
	TileManager.tilemap_bounds_changed.connect(update_limits)
	if TileManager.current_tilemap_bounds:
		print("call update limits...")
		update_limits(TileManager.current_tilemap_bounds)


func update_limits(bounds: Array[Vector2]) -> void:
	if bounds == []:
		return
	print("Updating Camera Limits...")
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)
