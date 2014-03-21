extends Node2D

var current_scene = null
var current_level = 0

var map={"tile_name":"angulo plano inclinado"}

func _ready():
	var root = get_scene().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	map["triangulo"]=45
	map["cuadrado"]=0
	map["pinchos"]=0
	map["pinchos_sangre"]=0
	#... faltan tiles por meter en el mapa

func goto_scene(scene):
	var s = ResourceLoader.load(scene)
	current_scene.queue_free()
	current_scene = s.instance()
	get_scene().get_root().add_child(current_scene) 

func game_over():
	current_level=0
	goto_scene("res://game_over.xml")

func next_level():
	current_level = current_level + 1
	goto_scene("res://level"+str(current_level)+".xml")
