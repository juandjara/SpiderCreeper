extends Panel

var current_scene = null

func _on_button_pressed():
	print ("You died! restarting game")
	get_node("/root/global").goto_scene("res://tiletest.xml")

func _ready():
	get_node("Button").connect("pressed", self,"_on_button_pressed")