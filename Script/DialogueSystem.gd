extends CanvasLayer

@onready var char_box = $Panel/DialogBox/CharacterBox
@onready var label_character = $Panel/DialogBox/CharacterBox/LabelCharacter
@onready var label_dialog = $Panel/DialogBox/LabelDialog
@onready var next_button = $Panel/DialogBox/NextButton

var dialog_data = {
	# Level1
	"level1": [
		{"character": "", "text": "The forest is cold... yet his blood burns."},
		{"character": "", "text": "Every moment awake drains his strength — the curse of daylight without the Solaris Gem."},
		{"character": "", "text": "Only one thing feeds the flame inside him now: blood."},
		{"character": "", "text": "The creatures in the mist — Gelatus, oozing slimes — are his only salvation."},
		{"character": "", "text": "He must hunt... or wither."},
		#{"character": "", "text": ""},
	],
	# Level2
	# Level3
	"enterLevel3": [
		{"character": "", "text": "I feel my heart is burning."},
		{"character": "", "text": "I can feel, I am getting closer to my gem."}
	],
	"level5": [
		{"character": "", "text": "The Solaris Gem is near."},
		{"character": "", "text": "But so is he; the one who took everything."},
		{"character": "", "text": "There will be no more running. No more hiding."},
		{"character": "", "text": "Tonight, the flame will be extinguished... forever."}
	],
	"beforeBossFight": [
		{"character": "", "text": "The air shifts, thick, unnatural... as if the world itself holds its breath."},
		{"character": "", "text": "He steps into the clearing, where the light refuses to touch."},
		{"character": "", "text": "Something ancient stirs in the dark... watching, waiting."}
	],
}

var current_dialog = []
var current_index = 0
var typing_speed = 0.07
var is_typing = false
var skip_typing = false

func start_dialog(trigger_name):
	if dialog_data.has(trigger_name) and not Global.dialog_seen.get(trigger_name, false):
		current_dialog = dialog_data[trigger_name]
		current_index = 0
		Global.is_dialog_active = true
		Global.dialog_seen[trigger_name] = true
		show_dialog()

func show_dialog():
	if current_index < current_dialog.size():
		visible = true
		var dialog = current_dialog[current_index]
		label_dialog.text = dialog["text"]

		if dialog["character"] != "":
			label_character.text = dialog["character"]
			char_box.show()
		else:
			char_box.hide()

		await type_text(dialog["text"])
	else:
		visible = false
		current_dialog.clear()
		Global.is_dialog_active = false

func _on_next_button_pressed():
	if is_typing:
		skip_typing = true
	else:
		current_index += 1
		show_dialog()

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

# Level 1 Dialogues
func _on_level_1_dialogue_trigger_body_entered(body: Node2D):
	if body.name == "Player": 
		start_dialog("level1")

func _on_enter_level_3_dialogue_trigger_body_entered(body: Node2D):
	if body.name == "Player":
		start_dialog("enterLevel3")

func _on_level_5_dialogue_trigger_body_entered(body: Node2D):
	if body.name == "Player": 
		start_dialog("level5")

func _on_before_boss_dialogue_trigger_body_entered(body: Node2D):
	if body.name == "Player": 
		body.reset_health()
		start_dialog("beforeBossFight")
