extends Node2D
@onready var bluejay := $bluejay
@onready var cardinal := $cardinal
@onready var finch := $finch
@onready var pidgeon := $pidgeon
@onready var birdhouseAnim := $birdhouseAnim
@onready var hoverTimer := $hoverTimer
var bird_out := false
var bird_moving := false
var email_birds := false
var current_bird_out = null
var current_bird_hover = null
var active := false

signal bird_left
signal bird_returned
signal tween_birdhouse
signal menu_transition

func _ready() -> void:
	hoverTimer.timeout.connect(hoverTimeout)
	bluejay.button_pressed.connect(birdPressed.bind("bluejay"))
	cardinal.button_pressed.connect(birdPressed.bind("cardinal"))
	finch.button_pressed.connect(birdPressed.bind("finch"))
	pidgeon.button_pressed.connect(birdPressed.bind("pidgeon"))
	reset()

func birdHover(bird) -> void:
	if not active: return
	current_bird_hover = bird
	hoverTimer.stop()
	hoverTimer.start(0.25)
	
func hoverTimeout() -> void:
	if not active: return
	if current_bird_hover != null: birdLeave(current_bird_hover)
	
func birdLeave(bird) -> void:
	if bird == current_bird_out: return
	if not bird_out and not birdhouseAnim.is_playing():
		current_bird_out = bird
		birdhouseAnim.play("%s_leave" % bird)
		emit_signal("tween_birdhouse")
		if not birdhouseAnim.animation_finished.is_connected(birdLeft):
			birdhouseAnim.animation_finished.connect(birdLeft, CONNECT_ONE_SHOT)
	elif bird_out and current_bird_out != null and not birdhouseAnim.is_playing():
		birdhouseAnim.play_backwards("%s_leave" % current_bird_out)
		if not birdhouseAnim.animation_finished.is_connected(birdReturned):
			birdhouseAnim.animation_finished.connect(birdReturned, CONNECT_ONE_SHOT)

func birdLeft(_anim) -> void:
	bird_out = true
	emit_signal("bird_left")
	if not active: return
	if current_bird_hover != null: birdLeave(current_bird_hover)
	toggleBirdClick(current_bird_out, true)
	birdCall(current_bird_out)
	
func birdReturned(_anim) -> void:
	toggleBirdClick(current_bird_out, false)
	current_bird_out = null
	bird_out = false
	emit_signal("bird_returned")
	if not active: return
	if current_bird_hover != null: birdLeave(current_bird_hover)
	
func birdFlown(menu: String) -> void:
	bird_out = false
	reset()
	emit_signal("menu_transition", menu)
	
func birdCall(bird: String) -> void:
	AudioHandler.playSound("%s_call" % bird)

func birdSong(bird: String) -> void:
	AudioHandler.playSound("%s_song" % bird)

func wingFlap(bird: String) -> void:
	match bird:
		"bluejay": AudioHandler.playSound("wing_flap_1")
		"cardinal": AudioHandler.playSound("wing_flap_2")
		"finch": AudioHandler.playSound("wing_flap_3")
		"pidgeon": AudioHandler.playSound("wing_flap_4")
		
func birdFlyAway(menu_bird: String) -> void:
	active = false
	hoverTimer.stop()
	if not bird_out:
		if not birdhouseAnim.is_playing():
			birdLeave(menu_bird)
			await bird_left
			bird_out = false
			wingFlap(menu_bird)
			birdhouseAnim.play("%s_fly" % menu_bird)
		else:
			if birdhouseAnim.animation_finished.is_connected(birdReturned): birdhouseAnim.animation_finished.disconnect(birdReturned)
			if birdhouseAnim.animation_finished.is_connected(birdLeft): birdhouseAnim.animation_finished.disconnect(birdLeft)
			if current_bird_out == menu_bird:
				birdhouseAnim.animation_finished.connect(birdLeft)
				await bird_left
				birdFlyAway(menu_bird)
			else:
				birdhouseAnim.play_backwards(birdhouseAnim.current_animation)
				birdhouseAnim.animation_finished.connect(birdReturned)
				await bird_returned
				birdFlyAway(menu_bird)
	else:
		if current_bird_out == menu_bird: 
			bird_out = false
			wingFlap(menu_bird)
			birdhouseAnim.play("%s_fly" % menu_bird)
		else:
			if not birdhouseAnim.is_playing():
				birdLeave(menu_bird)
				await bird_left
				birdFlyAway(menu_bird)
			else:
				await bird_returned
				birdFlyAway(menu_bird)
		
func showMenu():
	active = true
	visible = true
	
func nullHoverBird():
	if not active: return
	current_bird_hover = null

func emailBirds(on: bool):
	if on:
		if email_birds: return 
		email_birds = on
		birdhouseAnim.play("email_birds")
	else: 
		if email_birds: birdhouseAnim.play_backwards("email_birds")
		email_birds = on

func birdPressed(bird: String):
	AudioHandler.playSound("%s_song" % bird)

func toggleBirdClick(bird: String, on: bool):
	match bird:
		"bluejay": bluejay.can_click = on
		"cardinal": cardinal.can_click = on
		"finch": finch.can_click = on
		"pidgeon": pidgeon.can_click = on
		
func reset() -> void:
	current_bird_hover = null
	current_bird_out = null
	bluejay.can_click = false
	cardinal.can_click = false
	finch.can_click = false
	pidgeon.can_click = false
	active = true
	if birdhouseAnim.animation_finished.is_connected(birdReturned): birdhouseAnim.animation_finished.disconnect(birdReturned)
	if birdhouseAnim.animation_finished.is_connected(birdLeft): birdhouseAnim.animation_finished.disconnect(birdLeft)
	birdhouseAnim.play("RESET")
