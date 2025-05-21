extends Node

signal tilemap_bounds_changed(bounds: Array[Vector2])

var current_tilemap_bounds: Array[Vector2]

func change_tilemap_bounds(bounds: Array[Vector2]) -> void:
	print("TileManager: Changing Camera Bounds: ", bounds)
	current_tilemap_bounds = bounds
	print("Connections before emit: ", get_signal_connection_list("tilemap_bounds_changed").size())
	tilemap_bounds_changed.emit(bounds)
	print("Signal emitted")
