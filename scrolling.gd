extends Node2D

var zero = Vector2(0,0)
var speed = 2

func _ready():
	set_fixed_process(true)

#metodo de gameloop especial para la física
func _fixed_process(state):
	if(Input.is_action_pressed("right")):
		#aplica un impulso en el rigidbody2D
		#el primer parametro es el punto donde se aplica la fuerza
		#(respecto del centro del objeto)
		#y el segundo la fuerza aplicada
		get_node("ball").apply_impulse(zero, Vector2(speed,0))
	
	if(Input.is_action_pressed("left")):
		get_node("ball").apply_impulse(zero, Vector2(-speed,0))
	