extends CanvasLayer

@onready var aboutButton := $homeControl/marginCont/vboxCont/aboutButton
@onready var resumeButton := $homeControl/marginCont/vboxCont/resumeButton
@onready var gamesButton := $homeControl/marginCont/vboxCont/gamesButton
@onready var contactButton := $homeControl/marginCont/vboxCont/contactButton
@onready var homeScreenAnim := $homeScreenAnim
@onready var homeControl := $homeControl

signal button_enter(bird)
signal button_exit()
signal menu_transition(menu)
signal reset_birds
var active := true

func _ready() -> void:
	aboutButton.mouse_entered.connect(handleButtonMouseEntered.bind(aboutButton))
	resumeButton.mouse_entered.connect(handleButtonMouseEntered.bind(resumeButton))
	gamesButton.mouse_entered.connect(handleButtonMouseEntered.bind(gamesButton))
	contactButton.mouse_entered.connect(handleButtonMouseEntered.bind(contactButton))
	
	aboutButton.mouse_exited.connect(handleButtonMouseExited.bind(aboutButton))
	resumeButton.mouse_exited.connect(handleButtonMouseExited.bind(resumeButton))
	gamesButton.mouse_exited.connect(handleButtonMouseExited.bind(gamesButton))
	contactButton.mouse_exited.connect(handleButtonMouseExited.bind(contactButton))
	
	aboutButton.pressed.connect(handleButtonPressed.bind(aboutButton))
	resumeButton.pressed.connect(handleButtonPressed.bind(resumeButton))
	contactButton.pressed.connect(handleButtonPressed.bind(contactButton))
	gamesButton.pressed.connect(handleButtonPressed.bind(gamesButton))
	reset()
	
func handleButtonMouseEntered(button):
	if not active: return
	AudioHandler.playSound("ui_click")
	button.get_child(0).visible = true
	birdLeaveHome(button)
	
func handleButtonMouseExited(button):
	if not active: return
	button.get_child(0).visible = false
	emit_signal("button_exit")
	
func handleButtonPressed(button):
	button.get_child(0).visible = false
	if not active: return
	var menu_bird
	match button:
		aboutButton: menu_bird = "bluejay"
		resumeButton: menu_bird = "finch"
		gamesButton: menu_bird = "cardinal"
		contactButton: menu_bird = "pidgeon"
	emit_signal("menu_transition", menu_bird)
	active = false
	homeScreenAnim.play("fade_out")
	AudioHandler.playSound("ui_click")
	
func birdLeaveHome(button):
	if not active: return
	var bird
	match button:
		aboutButton: bird = "bluejay"
		resumeButton: bird = "finch"
		gamesButton: bird = "cardinal"
		contactButton: bird = "pidgeon"
	emit_signal("button_enter", bird)

func loadMenu():
	visible = true
	homeScreenAnim.play_backwards("fade_out")
	await homeScreenAnim.animation_finished
	emit_signal("reset_birds")
	active = true
	
func hideMenu():
	visible = false

func reset():
	visible = true
	homeControl.modulate = Color.WHITE
