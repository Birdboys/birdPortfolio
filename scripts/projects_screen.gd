extends CanvasLayer

@onready var backButton := $projectControl/marginCont/backButton
@onready var projectBackButton := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/projectBackButton
@onready var leftButton := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVisual/leftButton
@onready var rightButton := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVisual/rightButton
@onready var blepPlayButton := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/blepScroll/descVbox/blepPlayButton
@onready var quickPlayButton := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/jammerScroll/descVbox/quickPlayButton
@onready var fitPlayButton := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/jammerScroll/descVbox/fitPlayButton
@onready var leavePlayButton := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/jammerScroll/descVbox/leavePlayButton
@onready var voiceCodeButton := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/voiceScroll/descVbox/voiceCodeButton
@onready var boxWatchButton := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/beatboxScroll/descVbox/boxWatchButton

@onready var projectControl := $projectControl
@onready var projectScreenAnim := $projectScreenAnim
@onready var sarpedonLabel := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/mainScroll/descVbox/sarpedonLabel
@onready var blepLabel := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/mainScroll/descVbox/blepLabel
@onready var jammerLabel := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/mainScroll/descVbox/jammerLabel
@onready var voiceLabel := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/mainScroll/descVbox/voiceLabel
@onready var beatboxLabel := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/mainScroll/descVbox/beatboxLabel
@onready var mediaLabel := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVisual/mediaLabel
@onready var projectImage := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVisual/projectImage
@onready var mainScroll := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/mainScroll
@onready var sarpedonScroll := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/sarpedonScroll
@onready var blepScroll := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/blepScroll
@onready var jammerScroll := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/jammerScroll
@onready var voiceScroll := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/voiceScroll
@onready var beatboxScroll := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/beatboxScroll
@export var projectMedia := {}
var active := false
var media_index := 0
var current_media : String
signal back_to_home

func _ready() -> void:
	backButton.pressed.connect(goBack)
	backButton.mouse_entered.connect(toggleShadow.bind(backButton, true))
	backButton.mouse_exited.connect(toggleShadow.bind(backButton, false))
	projectBackButton.mouse_entered.connect(toggleShadow.bind(projectBackButton, true))
	projectBackButton.mouse_exited.connect(toggleShadow.bind(projectBackButton, false))
	blepPlayButton.mouse_entered.connect(toggleShadow.bind(blepPlayButton, true))
	blepPlayButton.mouse_exited.connect(toggleShadow.bind(blepPlayButton, false))
	quickPlayButton.mouse_entered.connect(toggleShadow.bind(quickPlayButton, true))
	quickPlayButton.mouse_exited.connect(toggleShadow.bind(quickPlayButton, false))
	fitPlayButton.mouse_entered.connect(toggleShadow.bind(fitPlayButton, true))
	fitPlayButton.mouse_exited.connect(toggleShadow.bind(fitPlayButton, false))
	leavePlayButton.mouse_entered.connect(toggleShadow.bind(leavePlayButton, true))
	leavePlayButton.mouse_exited.connect(toggleShadow.bind(leavePlayButton, false))
	voiceCodeButton.mouse_entered.connect(toggleShadow.bind(voiceCodeButton, true))
	voiceCodeButton.mouse_exited.connect(toggleShadow.bind(voiceCodeButton, false))
	boxWatchButton.mouse_entered.connect(toggleShadow.bind(boxWatchButton, true))
	boxWatchButton.mouse_exited.connect(toggleShadow.bind(boxWatchButton, false))
	
	leftButton.pressed.connect(moveCarousel.bind(false))
	rightButton.pressed.connect(moveCarousel.bind(true))
	projectBackButton.pressed.connect(exitProject)
	blepPlayButton.pressed.connect(openLink.bind("https://play.google.com/store/apps/details?id=org.godotengine.blep&hl=en_US"))
	quickPlayButton.pressed.connect(openLink.bind("https://birdboys.itch.io/quicksave"))
	fitPlayButton.pressed.connect(openLink.bind("https://birdangutang.itch.io/fit-to-scale"))
	voiceCodeButton.pressed.connect(openLink.bind("https://github.com/Birdboys/Game_Voice_Control/tree/main"))
	leavePlayButton.pressed.connect(openLink.bind("https://birdboys.itch.io/lets-leave"))
	boxWatchButton.pressed.connect(openLink.bind("https://www.youtube.com/watch?v=K_C_pixdYO0"))
	sarpedonLabel.gui_input.connect(labelClicked.bind("sarpedon"))
	blepLabel.gui_input.connect(labelClicked.bind("blep"))
	jammerLabel.gui_input.connect(labelClicked.bind("jammer"))
	voiceLabel.gui_input.connect(labelClicked.bind("voice"))
	beatboxLabel.gui_input.connect(labelClicked.bind("beatbox"))
	
	reset()

func exitProject():
	leftButton.disabled = true
	rightButton.disabled = true
	projectBackButton.visible = false
	mainScroll.visible = true
	mediaLabel.visible = true
	projectImage.texture = null
	sarpedonScroll.visible = false
	blepScroll.visible = false
	jammerScroll.visible = false
	voiceScroll.visible = false
	beatboxScroll.visible = false
	projectBackButton.get_child(0).visible = false
	
	
func labelClicked(input: InputEvent, label):
	if not (input is InputEventMouseButton and input.button_index == MOUSE_BUTTON_LEFT and input.pressed): return
	current_media = label
	media_index = 0
	loadMedia(projectMedia[current_media][media_index])
	mediaLabel.visible = false
	leftButton.disabled = false
	rightButton.disabled = false
	mainScroll.visible = false
	projectBackButton.visible = true
	match label: 
		"sarpedon": sarpedonScroll.visible = true
		"blep":
			blepScroll.visible = true
			blepPlayButton.get_child(0).visible = false
		"jammer":
			jammerScroll.visible = true
			quickPlayButton.get_child(0).visible = false
			fitPlayButton.get_child(0).visible = false
			leavePlayButton.get_child(0).visible = false
		"voice":
			voiceScroll.visible = true
			voiceCodeButton.get_child(0).visible = false
		"beatbox":
			beatboxScroll.visible = true
			boxWatchButton.get_child(0).visible = false
	AudioHandler.playSound("ui_click")
	
func loadMedia(media):
	var new_media = load(media)
	projectImage.texture = new_media
		
func moveCarousel(right: bool):
	if right: media_index += 1
	else: media_index -= 1
	media_index = wrapi(media_index, 0, len(projectMedia[current_media]))
	loadMedia(projectMedia[current_media][media_index])
	AudioHandler.playSound("ui_click")
	
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
	projectScreenAnim.play_backwards("fade_out")
	await projectScreenAnim.animation_finished
	active = true
	
func goBack():
	if not active: return
	active = false
	projectScreenAnim.play("fade_out")
	AudioHandler.playSound("ui_click")
	await projectScreenAnim.animation_finished
	reset()
	emit_signal("back_to_home")
	
func reset():
	visible = false
	leftButton.disabled = true
	rightButton.disabled = true
	projectBackButton.visible = false
	mainScroll.visible = true
	mediaLabel.visible = true
	projectImage.texture = null
	sarpedonScroll.visible = false
	blepScroll.visible = false
	jammerScroll.visible = false
	voiceScroll.visible = false
	beatboxScroll.visible = false
	projectControl.modulate = Color.TRANSPARENT
