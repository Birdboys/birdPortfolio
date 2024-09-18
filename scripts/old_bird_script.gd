extends Sprite2D
#class_name Bird

@onready var anim := $anim
@export var bird_name : String
var out := false

signal bird_returned
signal flown_away

func leaveHome():
	if anim.animation_finished.is_connected(returned): 
		anim.animation_finished.disconnect(returned)
	anim.play("leave_home")
	print("LEAVING",name)
	
func returnHome():
	anim.play_backwards("leave_home", -1, )
	if not anim.animation_finished.is_connected(returned):
		anim.animation_finished.connect(returned, CONNECT_ONE_SHOT)
	print("RETURNING",name)

func left(_anim):
	emit_signal("bird_left")
	
func returned(_anim):
	out = false
	emit_signal("bird_returned")

func birdCall():
	if out: return
	out = true
	AudioHandler.playSound("%s_call" % bird_name)

func flyAway():
	anim.play("fly_away")

func flownAway():
	visible = false
	emit_signal("flown_away")

func reset():
	anim.play("RESET")
