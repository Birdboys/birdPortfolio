extends CanvasLayer

@onready var backButton := $contactControl/marginCont/backButton
@onready var contactControl := $contactControl
@onready var contactScreenAnim := $contactScreenAnim
@onready var emailButton := $contactControl/marginCont/contactBox/emailLabel
var active := false

signal email_birds(on: bool)
signal back_to_home

func _ready() -> void:
	backButton.pressed.connect(goBack)
	backButton.mouse_entered.connect(toggleShadow.bind(backButton, true))
	backButton.mouse_exited.connect(toggleShadow.bind(backButton, false))
	emailButton.mouse_entered.connect(toggleShadow.bind(emailButton, true))
	emailButton.mouse_exited.connect(toggleShadow.bind(emailButton, false))
	emailButton.gui_input.connect(emailInput)
	reset()

func emailInput(input: InputEvent):
	if input is InputEventMouseButton and input.button_index == MOUSE_BUTTON_LEFT and input.pressed:
		OS.shell_open("mailto:colbybbusiness@gmail.com")
		AudioHandler.playSound("ui_click")
		
func toggleShadow(button, on: bool):
	if not active: return
	button.get_child(0).visible = on
	if on: AudioHandler.playSound("ui_hover")
	if button == emailButton and on: emit_signal("email_birds", on)
	
func loadMenu():
	visible = true
	backButton.get_child(0).visible = false
	contactScreenAnim.play_backwards("fade_out")
	await contactScreenAnim.animation_finished
	active = true
	
func goBack():
	if not active: return
	active = false
	contactScreenAnim.play("fade_out")
	emit_signal("email_birds", false)
	AudioHandler.playSound("ui_click")
	await contactScreenAnim.animation_finished
	visible = false
	emit_signal("back_to_home")
	
func reset():
	visible = false
	contactControl.modulate = Color.TRANSPARENT
