extends Node2D

#todavia no se como van los export u.u
export var speed = 1

func _ready():
	set_fixed_process(true)

#metodo de gameloop especial para la física
func _fixed_process(delta):
	#velocidad del rigidbody2D
	var lv = get_node("ball").get_linear_velocity()
	if(Input.is_action_pressed("ui_right")):
		#aplica un impulso en el rigidbody2D
		#el primer parametro es el punto donde se aplica la fuerza
		#(respecto del centro del objeto)
		#y el segundo la fuerza aplicada
		get_node("ball").apply_impulse(Vector2(0,0), Vector2(speed,0))
	
	if(Input.is_action_pressed("ui_left")):
		get_node("ball").apply_impulse(Vector2(0,0), Vector2(-speed,0))
	