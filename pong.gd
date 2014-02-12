
extends Node2D

var screen_size
var pad_size
var pts1 = 0; var pts2 = 0

func _ready():
	screen_size = get_viewport_rect().size
	pad_size = get_node("j1").get_texture().get_size()
	set_process(true)

var ball_speed = 80
var direction = Vector2(-1,0)
const PAD_SPEED = 150

func _process(delta):
	var ball_pos = get_node("ball").get_pos()
	var left_pos = get_node("j1").get_pos()
	var right_pos = get_node("j2").get_pos()
	var left_rect = Rect2(left_pos - pad_size/2, pad_size)
	var right_rect = Rect2(right_pos - pad_size/2, pad_size)
	get_node("Label1").set_text(str(pts1))
	get_node("Label2").set_text(str(pts2))
	
	#new pos
	ball_pos += direction* ball_speed* delta
	#test colisions
	# colisiones arriba y abajo
	if((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y = -direction.y
	
	# colsiones con las raquetas
	if((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x = -direction.x
		ball_speed *= 1.1
		direction.y = randf()*2.0-1
		direction = direction.normalized()
	
	# gameover
	if(ball_pos.x < 0 or ball_pos.x > screen_size.x):
		if(ball_pos.x < 0):
			pts1+=1
			direction = Vector2(1,0)
		if(ball_pos.x > screen_size.x):
			pts2+=1
			direction = Vector2(-1,0)
		ball_pos = screen_size/2 #center ball
		ball_speed = 80
	
	#update ball
	get_node("ball").set_pos(ball_pos)
	
	#move pads
	if(left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
		#print("moving left up")
		left_pos.y += -PAD_SPEED* delta
	if(left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
		#print("moving left down")
		left_pos.y += PAD_SPEED* delta
	get_node("j1").set_pos(left_pos)
	
	if(right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
		#print("moving right up")
		right_pos.y += -PAD_SPEED* delta
	if(right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
		#print("moving right down")
		right_pos.y += PAD_SPEED* delta
	get_node("j2").set_pos(right_pos)