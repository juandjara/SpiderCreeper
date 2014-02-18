
extends RigidBody2D

var max_jumptime = 20
var jumptime = 0
var jumping = false
var in_air = false
var dy = 0
export var jump_speed = -330

func _ready():
	set_use_custom_integrator(true)
	set_can_sleep(false)

func _integrate_forces(state):
	var lv = state.get_linear_velocity() #velocidad
	var step = state.get_step() #delta
	
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
	var down = Vector2(0,-1)
	for x in range(state.get_contact_count()):
		#para que esto funcione
		#el rigidbody2d tiene que tener la propiedad
		#"contact monitor" on
		#y "contacts reported" > 0
		#en el editor grafico
		if(state.get_contact_count() > 0):
			in_air = false
		#var collider = state.get_contact_collider_object(x)
		#if(collider.get_name() == "ground"):
		#	in_air = false
	lv.y+=dy
	lv += state.get_total_gravity()* step
	state.set_linear_velocity(lv)
