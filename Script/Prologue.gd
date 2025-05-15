extends Control

@onready var label = $RichTextLabel

var prologue_lines = [
	"[i]For centuries, the world forgot his name…[/i]",
	"",
	"Deep in a shadowed land stood an old, silent castle. Inside, a vampire named [b]Noctis[/b] slept — a noble of ancient blood, long lost to time.",
	"",
	"He survived thanks to the [color=gold][b]Solaris Gem[/b][/color] — a glowing relic from Queen Malavara that let him walk in sunlight, safe from its deadly touch.",
	"",
	"[b]But peace never lasts.[/b]",
	"",
	"One evening, Noctis awoke. Something felt wrong. And when he looked for the gem… [b][color=crimson]it was gone[/color][/b].",
	"",
	"As sunlight broke through the window, burning his skin, he knew — [i]the bond was broken.[/i]",
	"",
	"[b][color=red]Someone had stolen it.[/color][/b]",
	"",
	"Anger rising, Noctis stood once more. He would find the thief, uncover the truth, and take back what was his.",
	"",
	"[i]Alone, he steps into the night.[/i]",
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
