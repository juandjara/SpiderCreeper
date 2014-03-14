
extends TextureButton

func _input_event(ev):
	if(ev.type == InputEvent.MOUSE_BUTTON and ev.pressed):
		print("button pressed")
		update()
		var pos = get_node("logo").call("get_pos")
		get_node("logo").call("set_pos", Vector2(pos.x+5,pos.y))
		


