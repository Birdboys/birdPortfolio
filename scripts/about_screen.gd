extends CanvasLayer

@onready var backButton := $aboutControl/marginCont/backButton
@onready var imageTimer := $imageTimer
@onready var imageCarousel := $aboutControl/marginCont/titleVbox/imagePanel/image
@onready var aboutControl := $aboutControl
@onready var aboutScreenAnim := $aboutScreenAnim
@onready var leftButton := $aboutControl/marginCont/titleVbox/imagePanel/leftButton
@onready var rightButton := $aboutControl/marginCont/titleVbox/imagePanel/rightButton
@onready var itchButton := $aboutControl/marginCont/titleVbox/linksBox/itchButton
@onready var githubButton := $aboutControl/marginCont/titleVbox/linksBox/githubButton
@onready var linkedButton := $aboutControl/marginCont/titleVbox/linksBox/linkedButton

@onready var image_id := 0
@export var images : Array[Texture2D]
var active := false

signal back_to_home

func _ready() -> void:
	backButton.pressed.connect(goBack)
	backButton.mouse_entered.connect(toggleShadow.bind(backButton, true))
	backButton.mouse_exited.connect(toggleShadow.bind(backButton, false))
	leftButton.pressed.connect(moveCarousel.bind(false))
	rightButton.pressed.connect(moveCarousel.bind(true))
	itchButton.pressed.connect(openLink.bind("https://birdboys.itch.io/"))
	githubButton.pressed.connect(openLink.bind("https://github.com/Birdboys"))
	linkedButton.pressed.connect(openLink.bind("https://linkedin.com/in/colby-bird-9aba212a4/"))
	reset()

func openLink(link):
	AudioHandler.playSound("ui_click")
	OS.shell_open(link)
	
func toggleShadow(button, on: bool):
	if not active: return
	button.get_child(0).visible = on
	if on: AudioHandler.playSound("ui_hover")
	
func loadMenu():
	visible = true
	backButton.get_child(0).visible = false
	loadImage(image_id)
	aboutScreenAnim.play_backwards("fade_out")
	await aboutScreenAnim.animation_finished
	active = true
	
func loadImage(im):
	imageCarousel.texture = images[im]

func moveCarousel(right: bool):
	if right: image_id += 1
	else: image_id -= 1
	image_id = wrapi(image_id, 0, len(images))
	loadImage(image_id)
	AudioHandler.playSound("ui_click")
	
func goBack():
	if not active: return
	active = false
	aboutScreenAnim.play("fade_out")
	AudioHandler.playSound("ui_click")
	await aboutScreenAnim.animation_finished
	visible = false
	emit_signal("back_to_home")
	
func reset():
	visible = false
	aboutControl.modulate = Color.TRANSPARENT
