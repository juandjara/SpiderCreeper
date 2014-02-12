
extends Node2D

var speed = 1
var bg1_size
func _ready():
	var bg1_size = get_node("bg1").get_texture().get_size()
	set_process(true)

func _process(delta):
	var bg1_pos = get_node("bg1").get_pos()
	bg1_pos.x -= speed
	# if(bg1_pos.x > bg1_size.x):
	#	 bg1_pos.x=0
	if(bg1_pos.x < -700):
		bg1_pos.x=0
	get_node("bg1").set_pos(bg1_pos)
