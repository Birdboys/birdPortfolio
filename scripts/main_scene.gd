extends Node2D

@onready var mainCam := $mainCam
@onready var homeScreen := $homeScreen
@onready var aboutScreen := $aboutScreen
@onready var resumeScreen := $resumeScreen
@onready var contactScreen := $contactScreen
@onready var projectsScreen := $projectsScreen
@onready var birdHandler := $birdHandler
@onready var cam_home_pos := Vector2(-256, -156)
@onready var cam_about_pos := Vector2(-820, -640)
@onready var cam_resume_pos := Vector2(1112, -40)
@onready var cam_contact_pos := Vector2(-301, 944)
@onready var cam_project_pos := Vector2(-1456, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	homeScreen.button_enter.connect(birdHandler.birdHover)
	homeScreen.button_exit.connect(birdHandler.nullHoverBird)
	homeScreen.menu_transition.connect(birdHandler.birdFlyAway)
	homeScreen.reset_birds.connect(birdHandler.reset)
	birdHandler.menu_transition.connect(transitionMenu)
	contactScreen.email_birds.connect(birdHandler.emailBirds)
	
	mainCam.position = cam_home_pos
	
func resetMenus():
	homeScreen.reset()
	aboutScreen.reset()
	resumeScreen.reset()
	projectsScreen.reset()
	
func transitionMenu(menu):
	var new_pos 
	var next_menu
	match menu:
		"about":
			aboutScreen.back_to_home.connect(transitionMenu.bind("home"), CONNECT_ONE_SHOT)
			new_pos = cam_about_pos
			next_menu = aboutScreen
		"projects":
			projectsScreen.back_to_home.connect(transitionMenu.bind("home"), CONNECT_ONE_SHOT)
			new_pos = cam_project_pos
			next_menu = projectsScreen
		"resume":
			resumeScreen.back_to_home.connect(transitionMenu.bind("home"), CONNECT_ONE_SHOT)
			new_pos = cam_resume_pos
			next_menu = resumeScreen
		"contact":
			contactScreen.back_to_home.connect(transitionMenu.bind("home"), CONNECT_ONE_SHOT)
			new_pos = cam_contact_pos
			next_menu = contactScreen
		"home":
			new_pos = cam_home_pos
			next_menu = homeScreen
	var cam_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	cam_tween.tween_property(mainCam, "position", new_pos, 1.0)
	cam_tween.tween_callback(next_menu.loadMenu)
	cam_tween.tween_callback(birdHandler.reset)
