
extends RigidBody2D

var max_jumptime = 25
var jumptime = 0
var jumping = false 
var in_air = false
var in_rampa = false
var dy = 0
var dx = 0
var MAX_WALK_SPEED = 110

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
	dx = 0 
	var lv = state.get_linear_velocity() #velocidad
	var step = state.get_step() #delta
	 
	for col_index in range(state.get_contact_count()):
		var tile_name = get_coliding_tile_name(col_index, state)
		var obj_name = get_coliding_obj_name(col_index, state)
		#game over
		if(obj_name.begins_with("Enemy")):
			die()
		if(tile_name.begins_with("pinchos")):
			die()
		if(tile_name == "triangulo" and not in_air):
			in_rampa = true
		else:
			in_rampa = false
		#nextlevel
		if(tile_name.begins_with("meta")):
			get_node("/root/global").next_level()
	handle_jump(lv, step, state)
	
	if(not in_rampa):
		move_on_gronud(lv, step)
	else:
		move_on_rampa(lv, step)
	#aplicar cambios
	lv.x+=dx
	lv.y+=dy
	lv += state.get_total_gravity()* step
	state.set_linear_velocity(lv)

func die():
	get_node("/root/global").game_over()

#funcion con valores por defecto
func get_coliding_tile_name(col_index=0, state=null):
	var col_pos = state.get_contact_collider_pos(col_index)
	var tile_rel_pos = col_pos/tile_size
	var tilemap = get_parent().get_node("TileMap")
	var tile_id = tilemap.get_cell(tile_rel_pos.x, tile_rel_pos.y)
	return tilemap.get_tileset().tile_get_name(tile_id)

func get_coliding_obj_name(col_index=0, state=null):
	var collider = state.get_contact_collider_object(col_index)
	if(collider != null):
		return collider.get_name()
	else:
		return "none"

func handle_jump(lv, step, state):
	var jump_press = Input.is_action_pressed("jump")
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
	#si "contacts reported < 1 esto no va"
	var colisions = state.get_contact_count()
	print("C: " + str(colisions))
	if(colisions > 0):
		if(not jump_press):
			in_air = false
			if(lv.y < 0):
				dy = 0
				lv.y = 0
	else:
		in_air = true

func move_on_gronud(lv, step):
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

func move_on_rampa(lv, step):
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var ramp_angle = deg2rad(45)
	#mover a la izquierda
	if(left and not right and lv.x > -MAX_WALK_SPEED):
		var dv = -walk_speed*step*100
		dx = cos(ramp_angle) * dv
		dy = -sin(ramp_angle) * dv 
		get_child(0).set_flip_h(true)
	#mover a la derecha
	if(right and not left and lv.x < MAX_WALK_SPEED):
		var dv = walk_speed*step*100
		dx = cos(ramp_angle) * dv
		dy = -sin(ramp_angle) * dv 
		get_child(0).set_flip_h(false)
