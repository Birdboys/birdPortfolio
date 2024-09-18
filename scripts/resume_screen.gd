extends CanvasLayer

@onready var backButton := $resumeControl/marginCont/backButton
@onready var resumeControl := $resumeControl
@onready var resumeScreenAnim := $resumeScreenAnim
@onready var viewButton := $resumeControl/marginCont/detailsVbox/resumeButtons/viewButton
@onready var downloadButton := $resumeControl/marginCont/detailsVbox/resumeButtons/downloadButton
var active := false

signal back_to_home

func _ready() -> void:
	backButton.pressed.connect(goBack)
	backButton.mouse_entered.connect(toggleShadow.bind(backButton, true))
	backButton.mouse_exited.connect(toggleShadow.bind(backButton, false))
	viewButton.mouse_entered.connect(toggleShadow.bind(viewButton, true))
	viewButton.mouse_exited.connect(toggleShadow.bind(viewButton, false))
	downloadButton.mouse_entered.connect(toggleShadow.bind(downloadButton, true))
	downloadButton.mouse_exited.connect(toggleShadow.bind(downloadButton, false))
	
	viewButton.pressed.connect(viewResume)
	downloadButton.pressed.connect(downloadResume)
	reset()

func viewResume():
	OS.shell_open("https://drive.google.com/file/d/1z3cW-8fZ_HpCbL9_xP_04Xji3CrmUHts/view?usp=sharing")
	AudioHandler.playSound("ui_click")
	
func downloadResume():
	OS.shell_open("https://drive.google.com/uc?export=download&id=1z3cW-8fZ_HpCbL9_xP_04Xji3CrmUHts")
	AudioHandler.playSound("ui_click")
	
func toggleShadow(button, on: bool):
	if not active: return
	button.get_child(0).visible = on
	if on: AudioHandler.playSound("ui_click")
	
func loadMenu():
	visible = true
	resumeScreenAnim.play_backwards("fade_out")
	await resumeScreenAnim.animation_finished
	active = true
	
func goBack():
	if not active: return
	active = false
	resumeScreenAnim.play("fade_out")
	await resumeScreenAnim.animation_finished
	visible = false
	emit_signal("back_to_home")
	
func reset():
	visible = false
	resumeControl.modulate = Color.TRANSPARENT
