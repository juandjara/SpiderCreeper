
extends RigidBody2D

var max_jumptime = 25
var jumptime = 0
var jumping = false 
var in_air = false
var dy = 0
var MAX_WALK_SPEED = 101

var screen_size
var sprite_size
var tile_size

var walk_speed = 100
var jump_speed = -330


func _ready():
	set_use_custom_integrator(true)
	set_can_sleep(false)
	screen_size = get_viewport_rect().size
	sprite_size = get_child(0).get_texture().get_size()
	tile_size = get_parent().get_node("TileMap").get_cell_size()

func _integrate_forces(state):
	var lv = state.get_linear_velocity() #velocidad
	var step = state.get_step() #delta
	
	var jump_press = Input.is_action_pressed("jump")
	#gestionando salto
	if(jump_press or in_air):
		if(not in_air):
			jumping=true
			dy = jump_speed* step
			in_air=true
			jumptime = 0
		else:
			if(jumping and jumptime > max_jumptime):
				jumping=false
				dy = 0
				jumptime = 0
			elif(jumping):
				jumptime += 1
	
	#comprobando colisiones (comprobando num. colisiones > 0)
		#para que esto funcione
		#el rigidbody2d tiene que tener la propiedad
		#y "contacts reported" > 0
		#en el editor grafico
	var colisions = state.get_contact_count()
	print("C: " + str(colisions))
	if(colisions > 0):
		if(not jumping):
			in_air = false
			if(lv.y < 0):
				dy = 0
				lv.y = 0
	else:
		in_air = true
	
	
	for x in range(state.get_contact_count()):
		var col_pos = state.get_contact_collider_pos(x)
		var tile_rel_pos = col_pos/tile_size
		var tile_id = get_parent().get_node("TileMap").get_cell(tile_rel_pos.x, tile_rel_pos.y)
		var tile_name = get_parent().get_node("TileMap").get_tileset().tile_get_name(tile_id)
		
		#game over
		if(tile_name == "pinchos" or tile_name == "pinchos_sangre" or tile_name == "pinchos_vertical"):
			get_node("/root/global").goto_scene("res://game_over.xml")
		#nextlevel
		if(tile_name =="meta"):
			get_node("/root/global").goto_scene("res://level1.xml")
		if(tile_name =="meta 2"):
			get_node("/root/global").goto_scene("res://level2.xml")
		if(tile_name =="meta 3"):
			get_node("/root/global").goto_scene("res://level3.xml")
		if(tile_name =="meta 4"):
			get_node("/root/global").goto_scene("res://level4.xml")





	var dx = 0
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	#mover a la izquierda
	if(left and not right and lv.x > -MAX_WALK_SPEED):
		dx = -walk_speed*step*100
		get_child(0).set_flip_h(true)
	#mover a la derecha
	if(right and not left and lv.x < MAX_WALK_SPEED):
		dx = walk_speed*step*100
		get_child(0).set_flip_h(false)
	#colision bordes
	#if(get_pos().x < sprite_size.x/2 or get_pos().x > screen_size.x - sprite_size.x/2):
	#	lv.x=0
	#aplicar cambios
	lv.x+=dx
	lv.y+=dy
	lv += state.get_total_gravity()* step
	state.set_linear_velocity(lv)
