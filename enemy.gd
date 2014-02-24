
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var direccion= true#izquierda=false, derecha=true
#encaja mejor como vector?
var speed =2
var direction=1
var rc_left=null
var rc_right=null
var timer = null
var zero = Vector2(0,0)

func _process(delta):
	apply_impulse(zero, Vector2(direction*speed, 0))

func _on_timeout():
	direction = -direction

func _ready():
	set_process(true)
	timer = get_node("timer")
	timer.connect("timeout", self, "_on_timeout")


