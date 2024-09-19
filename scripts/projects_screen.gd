extends CanvasLayer

@onready var backButton := $projectControl/marginCont/backButton
@onready var projectBackButton := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVbox/projectBackButton
@onready var leftButton := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVisual/leftButton
@onready var rightButton := $projectControl/marginCont/detailsVbox/projectArea/projectHbox/projectVisual/rightButton
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
	leftButton.pressed.connect(moveCarousel.bind(false))
	rightButton.pressed.connect(moveCarousel.bind(true))
	projectBackButton.pressed.connect(exitProject)
	sarpedonLabel.gui_input.connect(labelClicked.bind("sarpedon"))
	blepLabel.gui_input.connect(labelClicked.bind("blep"))
	jammerLabel.gui_input.connect(labelClicked.bind("jammer"))
	voiceLabel.gui_input.connect(labelClicked.bind("voice"))
	beatboxLabel.gui_input.connect(labelClicked.bind("beatbox"))
	
	reset()

func exitProject():
	projectBackButton.visible = false
	projectBackButton.get_child(0).visible = false
	mainScroll.visible = true
	sarpedonScroll.visible = false
	
func labelClicked(input: InputEvent, label):
	if not (input is InputEventMouseButton and input.button_index == MOUSE_BUTTON_LEFT and input.pressed): return
	if label not in ["sarpedon", "blep"]: return
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
	AudioHandler.playSound("ui_click")
	
func loadMedia(media):
	var new_media = load(media)
	projectImage.texture = new_media
		
func moveCarousel(right: bool):
	if right: media_index += 1
	else: media_index -= 1
	media_index = wrapi(media_index, 0, len(projectMedia[current_media]))
	loadMedia(projectMedia[current_media][media_index])
	
func toggleShadow(button, on: bool):
	if not active: return
	button.get_child(0).visible = on
	if on: AudioHandler.playSound("ui_click")
		
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
	await projectScreenAnim.animation_finished
	reset()
	emit_signal("back_to_home")
	
func reset():
	visible = false
	projectImage.texture = null
	mediaLabel.visible = true
	leftButton.disabled = true
	rightButton.disabled = true
	projectBackButton.visible = false
	mainScroll.visible = true
	sarpedonScroll.visible = false
	projectControl.modulate = Color.TRANSPARENT
