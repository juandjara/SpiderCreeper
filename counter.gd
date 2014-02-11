
extends Label

var contador = 0

func _ready():
	set_process(true)

func _process(delta):
	contador+=delta
	set_text(str(contador))
