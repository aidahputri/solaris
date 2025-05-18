extends Control

@onready var bg_texture = $BgControl/Background
@onready var anim_player = $AnimationPlayer
@onready var char_box = $Dialogue/Panel/DialogBox/CharacterBox
@onready var label_character = $Dialogue/Panel/DialogBox/CharacterBox/LabelCharacter
@onready var label_dialog = $Dialogue/Panel/DialogBox/LabelDialog
@onready var next_button = $Dialogue/Panel/DialogBox/NextButton
@export var next_scene = ""

var dialog_data = [
	{"character": "", "text": "Long forgotten, the vampire Noctis slept in silence.", "bg": "res://Asset/Background/prologue-1.png"},
	{"character": "", "text": "He was protected by the Solaris Gem, a gift that let him walk in sunlight."},
	{"character": "", "text": "But one day, he awoke — and the gem was gone.", "bg": "res://Asset/Background/prologue-2.png"},
	{"character": "", "text": "Sunlight burned. Someone had stolen it."},
	{"character": "", "text": "Noctis rose, filled with fury.", "bg": "res://Asset/Background/prologue-3.png"},
	{"character": "", "text": "He would find the thief."},
	{"character": "", "text": "The hunt begins."},
	#{"character": "", "text": "", "bg": ""},
]
var current_index = 0
var typing_speed = 0.07
var is_typing = false
var skip_typing = false

func _ready():
	show_dialog()
	
func show_dialog():
	if current_index < dialog_data.size():
		var current_dialog = dialog_data[current_index]
		var raw_text = current_dialog["text"]
		var centered_text = "[center]" + raw_text + "[/center]"
		label_dialog.text = centered_text

		if current_dialog["character"] != "":
			label_character.text = current_dialog["character"]
			char_box.show()
		else:
			char_box.hide()

		if "bg" in current_dialog:
			if current_index > 0 and "bg" in dialog_data[current_index - 1]: 
				if current_dialog["bg"] != dialog_data[current_index - 1]["bg"]:
					anim_player.play("fade_out")
					await anim_player.animation_finished
			
			bg_texture.texture = load(current_dialog["bg"])
			anim_player.play("fade_in")
		
		await type_text(current_dialog["text"])
	else:
		queue_free()

func _on_next_button_pressed():
	if is_typing:
		skip_typing = true
	else:
		current_index += 1
		if current_index < dialog_data.size():
			show_dialog()
		else:
			go_to_next_scene()

func type_text(text: String):
	is_typing = true
	skip_typing = false
	label_dialog.text = ""
	for i in range(text.length()):
		if skip_typing:
			label_dialog.text = text
			break
		label_dialog.text += text[i]
		await get_tree().create_timer(typing_speed).timeout
	is_typing = false

func go_to_next_scene():
	anim_player.play("fade_out")
	await anim_player.animation_finished
	call_deferred("change_scene")
	
func change_scene():
	get_tree().change_scene_to_file(next_scene)
	
func _on_skip_pressed():
	go_to_next_scene()
