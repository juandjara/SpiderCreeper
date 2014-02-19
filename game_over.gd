extends Panel

var current_scene = null

func _on_button_pressed():
	print ("You died! restarting game")
	

func _ready():
	get_node("Button").connect("pressed", self,"_on_button_pressed")
	var root = get_scene().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
