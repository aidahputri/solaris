extends Control

@onready var label = $RichTextLabel

var prologue_lines = [
  "[i]Long forgotten, the vampire Noctis slept in silence.[/i]",
  "",
  "He was protected by the [b][color=gold]Solaris Gem[/color][/b], a gift that let him walk in sunlight.",
  "",
  "But one day, he awoke — and the gem was gone.",
  "",
  "[i]Sunlight burned.[/i] [b][color=crimson]Someone had stolen it.[/color][/b]",
  "",
  "Noctis rose, filled with fury.",
  "",
  "[i]He would find the thief.[/i]",
  "",
  "[b][color=white]The hunt begins.[/color][/b]"
]

func _ready():
	label.bbcode_enabled = true
	label.clear()
	start_prologue()

func start_prologue() -> void:
	show_next_line(0)

func show_next_line(index: int) -> void:
	if index >= prologue_lines.size():
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://Scene/Level1/Level1.tscn")
		return

	label.text = "[center]" + prologue_lines[index] + "[/center]"
	await get_tree().create_timer(3.0).timeout
	show_next_line(index + 1)
