extends TextureRect

func _ready():
	modulate.a = 0.0  # mulai transparan
	_animate_opacity()

func _animate_opacity():
	var tween = create_tween()
	tween.set_loops()  # loop selamanya

	# Durasi ditingkatkan jadi 2 detik per arah untuk efek lebih lembut
	tween.tween_property(self, "modulate:a", 1.0, 2.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 2.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
